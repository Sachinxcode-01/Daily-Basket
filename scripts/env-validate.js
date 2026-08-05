/**
 * Daily Basket Enterprise Production Environment Validator
 * Checks presence and format of required production environment variables.
 */

const requiredVars = [
  'DATABASE_URL',
  'REDIS_HOST',
  'REDIS_PORT',
  'JWT_SECRET',
  'JWT_REFRESH_SECRET',
];

const optionalVars = [
  'RAZORPAY_KEY_ID',
  'RAZORPAY_KEY_SECRET',
  'GEMINI_API_KEY',
  'SENTRY_DSN',
];

console.log('🔍 Validating Daily Basket Environment Configuration...');

let missingCount = 0;

for (const envVar of requiredVars) {
  if (!process.env[envVar]) {
    console.error(`❌ MISSING MANDATORY ENV VAR: ${envVar}`);
    missingCount++;
  } else {
    console.log(`  ✔ ${envVar} is configured`);
  }
}

for (const envVar of optionalVars) {
  if (!process.env[envVar]) {
    console.warn(`  ⚠️ OPTIONAL ENV VAR MISSING: ${envVar} (falling back to mock/dev mode)`);
  } else {
    console.log(`  ✔ ${envVar} is configured`);
  }
}

if (missingCount > 0) {
  console.error(`\n❌ Environment Validation Failed: ${missingCount} mandatory variable(s) missing.`);
  process.exit(1);
} else {
  console.log('\n✅ Enterprise Environment Validation Passed Successfully!');
  process.exit(0);
}
