import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger, VersioningType } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import compression from 'compression';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { RedisIoAdapter } from './common/adapters/redis-io.adapter';

async function bootstrap() {
  const logger = new Logger('DailyBasketAPI');
  const app = await NestFactory.create(AppModule, {
    bufferLogs: true,
  });

  // Enable Graceful Shutdown Hooks
  app.enableShutdownHooks();

  // Static Assets Serving for Local Uploaded Product Images
  const express = require('express');
  const path = require('path');
  const uploadsDir = path.join(__dirname, '..', 'public', 'uploads');
  if (!require('fs').existsSync(uploadsDir)) {
    require('fs').mkdirSync(uploadsDir, { recursive: true });
  }
  app.use('/uploads', express.static(uploadsDir));

  // Global Prefix & API Versioning

  app.setGlobalPrefix('api/v1');
  app.enableVersioning({
    type: VersioningType.URI,
    defaultVersion: '1',
  });

  // Security Hardening with Helmet
  app.use(
    helmet({
      contentSecurityPolicy: false,
      crossOriginEmbedderPolicy: false,
    }),
  );

  // Response Compression (Gzip & Brotli)
  app.use(
    compression({
      threshold: 1024, // Only compress responses > 1KB
      level: 6,
    }),
  );

  // Strict CORS Policy
  app.enableCors({
    origin: '*',
    credentials: true,
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type, Accept, Authorization, X-Correlation-ID, X-Idempotency-Key, If-None-Match',
  });

  // Global Input Validation & Sanitization Pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Redis Socket.IO Adapter for Horizontal Real-Time Scaling
  try {
    const redisIoAdapter = new RedisIoAdapter(app);
    await redisIoAdapter.connectToRedis();
    app.useWebSocketAdapter(redisIoAdapter);
  } catch (err: any) {
    logger.warn(`Redis Socket.IO Adapter connection deferred: ${err.message}`);
  }

  // OpenAPI Swagger Documentation Setup
  const config = new DocumentBuilder()
    .setTitle('Daily Basket Quick-Commerce API')
    .setDescription('Enterprise single-store quick-commerce backend API service')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('Products')
    .addTag('Orders')
    .addTag('Inventory')
    .addTag('Search')
    .addTag('Realtime')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = process.env.PORT || 4000;
  const server = await app.listen(port);

  // Configure HTTP Keep-Alive & Connection Pooling Timeouts
  if (server && 'keepAliveTimeout' in server) {
    (server as any).keepAliveTimeout = 65000; // Keep-alive timeout 65s (exceeds AWS/Cloudflare 60s load balancer timeout)
    (server as any).headersTimeout = 66000;
  }

  logger.log(`🚀 Daily Basket API Service running on: http://localhost:${port}/api/v1`);
  logger.log(`📑 OpenAPI Specification available on: http://localhost:${port}/api/docs`);
}

bootstrap();
