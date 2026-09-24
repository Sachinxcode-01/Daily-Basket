/**
 * Daily Basket — Cloudflare R2 Product Images Sync Script
 *
 * Uploads all deduplicated local images from `assets/products/`
 * to your Cloudflare R2 bucket with 0 npm dependencies (pure Node.js).
 *
 * Cloudflare R2 provides:
 * - 10 GB Free Storage
 * - $0 Bandwidth / Zero Egress Fees
 * - S3-compatible API
 *
 * Usage:
 *   node scripts/sync-images-to-r2.js
 */

const fs = require('fs');
const path = require('path');
const https = require('https');
const crypto = require('crypto');

// Load environment variables from services/api/.env
const envPath = path.resolve(__dirname, '../services/api/.env');
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf8');
  envContent.split('\n').forEach((line) => {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) return;
    const [key, ...vals] = trimmed.split('=');
    if (key && vals.length > 0) {
      const val = vals.join('=').replace(/^["']|["']$/g, '');
      if (!process.env[key]) {
        process.env[key] = val;
      }
    }
  });
}

const ACCOUNT_ID = process.env.CLOUDFLARE_R2_ACCOUNT_ID;
const ACCESS_KEY_ID = process.env.CLOUDFLARE_R2_ACCESS_KEY_ID;
const SECRET_ACCESS_KEY = process.env.CLOUDFLARE_R2_SECRET_ACCESS_KEY;
const BUCKET_NAME = process.env.CLOUDFLARE_R2_BUCKET_NAME || 'daily-basket-media';
const PUBLIC_URL = process.env.CLOUDFLARE_R2_PUBLIC_URL || '';

console.log('====================================================');
console.log('   DAILY BASKET — CLOUDFLARE R2 ASSET SYNC');
console.log('====================================================\n');

if (
  !ACCOUNT_ID ||
  ACCOUNT_ID === 'your_cloudflare_account_id' ||
  !ACCESS_KEY_ID ||
  ACCESS_KEY_ID === 'your_r2_access_key_id'
) {
  console.log('⚠️  Cloudflare R2 credentials not configured yet in `services/api/.env`.');
  console.log('\n--- Quick 60-Second Setup Guide ---');
  console.log('1. Open Cloudflare Dashboard (dash.cloudflare.com)');
  console.log('2. In the left sidebar, click "R2 Object Storage"');
  console.log('3. Click "Create bucket" -> Name it: `daily-basket-media`');
  console.log('4. On the right side, click "Manage R2 API Tokens" -> "Create API Token"');
  console.log('   - Permissions: Object Read & Write');
  console.log('   - Copy the "Access Key ID" and "Secret Access Key"');
  console.log('5. Under your bucket settings, enable "Public Development URL (r2.dev)"');
  console.log('6. Paste them into `services/api/.env`:');
  console.log('   CLOUDFLARE_R2_ACCOUNT_ID="<your-account-id>"');
  console.log('   CLOUDFLARE_R2_ACCESS_KEY_ID="<your-access-key>"');
  console.log('   CLOUDFLARE_R2_SECRET_ACCESS_KEY="<your-secret-key>"');
  console.log('   CLOUDFLARE_R2_BUCKET_NAME="daily-basket-media"');
  console.log('   CLOUDFLARE_R2_PUBLIC_URL="https://pub-xxxxxx.r2.dev"\n');

  // Preview local files ready for upload
  const baseDir = path.resolve(__dirname, '../assets/products');
  let count = 0;
  let sizeBytes = 0;
  if (fs.existsSync(baseDir)) {
    const cats = fs.readdirSync(baseDir);
    cats.forEach((cat) => {
      const catPath = path.join(baseDir, cat);
      if (fs.statSync(catPath).isDirectory()) {
        const files = fs.readdirSync(catPath).filter((f) => /\.(png|jpe?g|webp)$/i.test(f));
        count += files.length;
        files.forEach((f) => {
          sizeBytes += fs.statSync(path.join(catPath, f)).size;
        });
      }
    });
  }
  console.log(`📦 Status: ${count} deduplicated product images ready (${(sizeBytes / (1024 * 1024)).toFixed(2)} MB).`);
  console.log('When you add your credentials and run this script, all photos will upload automatically!\n');
  process.exit(0);
}

// AWS Signature V4 Signing Helpers for S3-compatible Cloudflare R2 API
function hmac(key, string) {
  return crypto.createHmac('sha256', key).update(string).digest();
}

function hash(string) {
  return crypto.createHash('sha256').update(string).digest('hex');
}

function getSignatureKey(key, dateStamp, regionName, serviceName) {
  const kDate = hmac('AWS4' + key, dateStamp);
  const kRegion = hmac(kDate, regionName);
  const kService = hmac(kRegion, serviceName);
  const kSigning = hmac(kService, 'aws4_request');
  return kSigning;
}

async function uploadFileToR2(filePath, objectKey, mimeType) {
  return new Promise((resolve, reject) => {
    const fileBuffer = fs.readFileSync(filePath);
    const contentPayloadHash = hash(fileBuffer);

    const now = new Date();
    const amzDate = now.toISOString().replace(/[:-]/g, '').split('.')[0] + 'Z';
    const dateStamp = amzDate.substring(0, 8);

    const host = `${BUCKET_NAME}.${ACCOUNT_ID}.r2.cloudflarestorage.com`;
    const region = 'auto';
    const service = 's3';

    const canonicalUri = '/' + objectKey.split('/').map(encodeURIComponent).join('/');
    const canonicalHeaders =
      `content-length:${fileBuffer.length}\n` +
      `content-type:${mimeType}\n` +
      `host:${host}\n` +
      `x-amz-content-sha256:${contentPayloadHash}\n` +
      `x-amz-date:${amzDate}\n`;

    const signedHeaders = 'content-length;content-type;host;x-amz-content-sha256;x-amz-date';
    const canonicalRequest = `PUT\n${canonicalUri}\n\n${canonicalHeaders}\n${signedHeaders}\n${contentPayloadHash}`;

    const credentialScope = `${dateStamp}/${region}/${service}/aws4_request`;
    const stringToSign = `AWS4-HMAC-SHA256\n${amzDate}\n${credentialScope}\n${hash(canonicalRequest)}`;
    const signingKey = getSignatureKey(SECRET_ACCESS_KEY, dateStamp, region, service);
    const signature = crypto.createHmac('sha256', signingKey).update(stringToSign).digest('hex');

    const authorizationHeader = `AWS4-HMAC-SHA256 Credential=${ACCESS_KEY_ID}/${credentialScope}, SignedHeaders=${signedHeaders}, Signature=${signature}`;

    const req = https.request(
      {
        host: host,
        port: 443,
        path: canonicalUri,
        method: 'PUT',
        headers: {
          Host: host,
          'Content-Type': mimeType,
          'Content-Length': fileBuffer.length,
          'x-amz-date': amzDate,
          'x-amz-content-sha256': contentPayloadHash,
          Authorization: authorizationHeader,
        },
      },
      (res) => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(true);
        } else {
          let errData = '';
          res.on('data', (c) => (errData += c));
          res.on('end', () => reject(new Error(`HTTP ${res.statusCode}: ${errData}`)));
        }
      }
    );

    req.on('error', reject);
    req.write(fileBuffer);
    req.end();
  });
}

async function run() {
  const baseDir = path.resolve(__dirname, '../assets/products');
  const categories = fs.readdirSync(baseDir);

  let successCount = 0;
  let failCount = 0;

  for (const cat of categories) {
    const catPath = path.join(baseDir, cat);
    if (!fs.statSync(catPath).isDirectory()) continue;

    const files = fs.readdirSync(catPath).filter((f) => /\.(png|jpe?g|webp)$/i.test(f));
    console.log(`\n📂 Uploading category [${cat}] (${files.length} images)...`);

    for (const file of files) {
      const filePath = path.join(catPath, file);
      const objectKey = `products/${cat}/${file}`;
      const mimeType = file.endsWith('.webp') ? 'image/webp' : 'image/png';

      try {
        await uploadFileToR2(filePath, objectKey, mimeType);
        successCount++;
        process.stdout.write(`  ✓ ${file}\n`);
      } catch (err) {
        failCount++;
        console.error(`  ✗ Failed: ${file} - ${err.message}`);
      }
    }
  }

  console.log('\n====================================================');
  console.log(`✅ Upload Complete!`);
  console.log(`   - Uploaded: ${successCount} files`);
  console.log(`   - Failed:   ${failCount} files`);
  if (PUBLIC_URL) {
    console.log(`   - Base CDN URL: ${PUBLIC_URL}/products/`);
  }
  console.log('====================================================\n');
}

run().catch(console.error);
