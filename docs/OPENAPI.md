# 📄 OpenAPI 3.0 & Swagger Reference — Daily Basket

NestJS API Gateway automatically generates OpenAPI 3.0 compliant JSON schemas and interactive documentation using `@nestjs/swagger`.

---

## 🚀 Accessing Swagger UI

When running the API service locally or in staging:
- **Swagger Interactive UI**: `http://localhost:4000/api/docs`
- **OpenAPI JSON Spec**: `http://localhost:4000/api/docs-json`
- **OpenAPI YAML Spec**: `http://localhost:4000/api/docs-yaml`

---

## 🛠️ NestJS Swagger Integration Code

In `services/api/src/main.ts`:

```typescript
const config = new DocumentBuilder()
  .setTitle('Daily Basket API')
  .setDescription('Enterprise 10-Minute Grocery Delivery Microservices API Gateway')
  .setVersion('1.0.0')
  .addBearerAuth({ type: 'http', scheme: 'bearer', bearerFormat: 'JWT' }, 'JWT-Auth')
  .build();

const document = SwaggerModule.createDocument(app, config);
SwaggerModule.setup('api/docs', app, document);
```

---

## 📋 Security Schemes

Swagger UI requires a JWT bearer token for authorized endpoints:
1. Click **Authorize** button in Swagger UI.
2. Enter token string: `Bearer <your_access_token>`.
3. Submit request against protected endpoints (`/orders`, `/payments`, `/delivery`).
