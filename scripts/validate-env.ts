declare const process: { env: Record<string, string | undefined>; exit: (code?: number) => void };

function validateEnvironmentVariables() {
  console.log('🔍 [Environment Validator] Validating environment configuration...');

  const requiredVars = [
    'DATABASE_URL',
    'REDIS_HOST',
    'REDIS_PORT',
    'JWT_SECRET',
  ];

  const missing: string[] = [];

  for (const key of requiredVars) {
    if (!process.env[key]) {
      missing.push(key);
    }
  }

  if (missing.length > 0) {
    console.error(`❌ Environment Validation Failed! Missing variables: ${missing.join(', ')}`);
    console.warn('⚠️ Please check your .env configuration file.');
    process.exit(1);
  }

  console.log('✅ Environment configuration validated successfully!');
}

validateEnvironmentVariables();
