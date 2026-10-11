const { execSync } = require('child_process');

console.log('Testing with pnpm exec jest...');
try {
  const out = execSync('pnpm exec jest src/modules/feature-flags/feature-flags.service.spec.ts --colors=false', {
    cwd: __dirname,
    encoding: 'utf8',
    timeout: 30000,
    env: { ...process.env, DATABASE_URL: 'postgresql://postgres:postgres@localhost:5432/daily_basket?schema=public' }
  });
  console.log('OUTPUT:\n', out);
} catch (err) {
  console.log('ERROR:\n', err.stdout || err.stderr || err.message);
}
