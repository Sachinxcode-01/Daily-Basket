const https = require('https');
const fs = require('fs');

const logPath = 'apps/mobile/test_log.txt';
if (!fs.existsSync(logPath)) {
  console.log('Log file does not exist:', logPath);
  process.exit(0);
}

const log = fs.readFileSync(logPath, 'utf8');
const lines = log.split(/\r?\n/);
const snippet = lines.slice(-150).join('\n').slice(0, 60000);

const title = process.env.LOG_TITLE || 'Flutter CI Test Log';
const body = '### ' + title + '\n```\n' + snippet + '\n```';
const payload = JSON.stringify({ body });

const repo = process.env.GITHUB_REPOSITORY;
let sha = process.env.GITHUB_SHA;
const token = process.env.GH_TOKEN;

if (!repo || !token) {
  console.log('Missing required env vars (GITHUB_REPOSITORY or GH_TOKEN). Skipping comment.');
  process.exit(0);
}

let commentPath = null;
let event = null;

if (process.env.GITHUB_EVENT_PATH && fs.existsSync(process.env.GITHUB_EVENT_PATH)) {
  try {
    event = JSON.parse(fs.readFileSync(process.env.GITHUB_EVENT_PATH, 'utf8'));
  } catch (e) {
    console.warn('Failed to parse GITHUB_EVENT_PATH JSON:', e.message);
  }
}

if (event && event.pull_request) {
  // For PRs, comment on the PR conversation thread if number exists
  if (event.pull_request.number) {
    commentPath = `/repos/${repo}/issues/${event.pull_request.number}/comments`;
  } else if (event.pull_request.head && event.pull_request.head.sha) {
    sha = event.pull_request.head.sha;
    commentPath = `/repos/${repo}/commits/${sha}/comments`;
  }
} else if (sha) {
  commentPath = `/repos/${repo}/commits/${sha}/comments`;
}

if (!commentPath) {
  console.log('Could not determine target comment endpoint. Skipping comment.');
  process.exit(0);
}

console.log(`Posting test log comment to GitHub API endpoint: ${commentPath}`);

const req = https.request({
  hostname: 'api.github.com',
  path: commentPath,
  method: 'POST',
  headers: {
    'User-Agent': 'NodeJS-GitHub-Actions',
    'Authorization': 'Bearer ' + token,
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(payload)
  }
}, res => {
  console.log('Comment post HTTP status:', res.statusCode);
  let responseData = '';
  res.on('data', chunk => { responseData += chunk; });
  res.on('end', () => {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      console.log('Successfully posted test log comment.');
    } else {
      console.warn(`Notice: GitHub API returned HTTP ${res.statusCode}.`);
      console.log('Log is preserved in step summary and workflow artifacts.');
    }
  });
});

req.on('error', err => {
  console.warn('Notice: Error sending comment to GitHub API:', err.message);
  console.log('Log is preserved in step summary and workflow artifacts.');
});

req.write(payload);
req.end();
