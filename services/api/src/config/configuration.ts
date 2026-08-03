export default () => ({
  environment: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT, 10) || 4000,
  database: {
    url: process.env.DATABASE_URL || 'postgresql://postgres:postgrespassword@localhost:5432/daily_basket?schema=public',
  },
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT, 10) || 6379,
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'super-secret-daily-basket-key-2026-min-32-chars',
    expiresIn: '15m',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'super-secret-daily-basket-refresh-key-2026',
    refreshExpiresIn: '7d',
  },
  s3: {
    bucket: process.env.AWS_S3_BUCKET || 'daily-basket-assets-dev',
    region: process.env.AWS_REGION || 'ap-south-1',
  },
});
