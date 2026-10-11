const https = require('https');
const fs = require('fs');

const logPath = 'apps/mobile/test_log.txt';
if (!fs.existsSync(logPath)) {
  console.log('Log file does not exist');
  process.exit(0);
}

const log = fs.readFileSync(logPath, 'utf8');
const lines = log.split(/\r?\n/);
const snippet = lines.slice(-150).join('\n').slice(0, 60000);

const title = process.env.LOG_TITLE || 'Flutter CI Test Log';
const body = '### ' + title + '\n```\n' + snippet + '\n```';
const payload = JSON.stringify({ body });

const repo = process.env.GITHUB_REPOSITORY;
const sha = process.env.GITHUB_SHA;
const token = process.env.GH_TOKEN;

if (!repo || !sha || !token) {
  console.log('Missing env vars:', { repo: !!repo, sha: !!sha, token: !!token });
  process.exit(0);
}

const req = https.request({
  hostname: 'api.github.com',
  path: `/repos/${repo}/commits/${sha}/comments`,
  method: 'POST',
  headers: {
    'User-Agent': 'NodeJS',
    'Authorization': 'token ' + token,
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(payload)
  }
}, res => {
  console.log('Comment post status:', res.statusCode);
  res.on('data', d => process.stdout.write(d));
});

req.on('error', err => console.error(err));
req.write(payload);
req.end();
