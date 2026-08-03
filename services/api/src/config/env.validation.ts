import * as Joi from 'joi';

export const envValidationSchema = Joi.object({
  NODE_ENV: Joi.string()
    .valid('development', 'production', 'test', 'staging')
    .default('development'),
  PORT: Joi.number().default(4000),
  DATABASE_URL: Joi.string().required(),
  REDIS_HOST: Joi.string().default('localhost'),
  REDIS_PORT: Joi.number().default(6379),
  JWT_SECRET: Joi.string().min(16).default('super-secret-daily-basket-key-2026-min-32-chars'),
  JWT_REFRESH_SECRET: Joi.string().min(16).default('super-secret-daily-basket-refresh-key-2026'),
  AWS_S3_BUCKET: Joi.string().default('daily-basket-assets-dev'),
  AWS_REGION: Joi.string().default('ap-south-1'),
});
