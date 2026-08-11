# Daily Basket — OpenAPI / Swagger Specification & API Guide

## Overview

The Daily Basket API service is built on NestJS, serving high-throughput quick-commerce transactions with real-time WebSocket updates, multi-layer Redis caching, and low-latency database queries.

- **Base URL**: `http://localhost:4000/api/v1` (Production: `https://api.dailybasket.in/api/v1`)
- **Swagger Interactive UI**: `http://localhost:4000/api/docs`
- **Protocol**: HTTP/1.1 & HTTP/2 with Keep-Alive, WebSocket (`/ws`)
- **Format**: JSON (`Content-Type: application/json`)

---

## Authentication & Headers

All protected endpoints require a Bearer JWT Token passed in the `Authorization` header.

```http
Authorization: Bearer <your_jwt_access_token>
X-Correlation-ID: <uuid_v4>
X-Idempotency-Key: <unique_request_key>
```

---

## Core API Endpoint Groups

### 1. Authentication & Security (`/api/v1/auth`)

| Verb | Endpoint | Description | Auth Required |
| :--- | :--- | :--- | :--- |
| `POST` | `/auth/request-otp` | Sends OTP to phone number with 60s cooldown | No |
| `POST` | `/auth/verify-otp` | Verifies 6-digit OTP and returns JWT tokens | No |
| `POST` | `/auth/refresh-token` | Rotates refresh token & issues new access token | Yes |
| `POST` | `/auth/logout` | Revokes active device session | Yes |

#### Sample Request: `POST /api/v1/auth/request-otp`
```json
{
  "phone": "9876543210"
}
```

#### Sample Response: `200 OK`
```json
{
  "success": true,
  "phone": "9876543210",
  "demoOtp": "123456",
  "resendCooldownSeconds": 60,
  "message": "OTP sent successfully to +91 9876543210"
}
```

---

### 2. Product Catalog (`/api/v1/products`)

| Verb | Endpoint | Description | Auth Required | Cache |
| :--- | :--- | :--- | :--- | :--- |
| `GET` | `/products` | Fetches active product catalog with variants | No | 60s |
| `GET` | `/products/:slug` | Retrieves product details by URL slug | No | 300s |
| `GET` | `/products/category/:categoryId` | Fetches products in a specific category | No | 60s |

---

### 3. Quick-Commerce Orders (`/api/v1/orders`)

| Verb | Endpoint | Description | Auth Required | Idempotent |
| :--- | :--- | :--- | :--- | :--- |
| `POST` | `/orders` | Places a new 10-min delivery order | Yes | Yes |
| `GET` | `/orders` | Returns paginated list of user's orders | Yes | No |
| `GET` | `/orders/:id` | Fetches order status, line items, and ETA | Yes | No |
| `PATCH` | `/orders/:id/cancel` | Cancels order and releases reserved stock | Yes | Yes |

---

### 4. Inventory Concurrency Control (`/api/v1/inventory`)

| Verb | Endpoint | Description | Auth Required |
| :--- | :--- | :--- | :--- |
| `GET` | `/inventory/store/:storeId` | Returns dark store inventory levels | Yes (Staff) |
| `PUT` | `/inventory/stock` | Atomic stock update & real-time broadcast | Yes (Staff) |

---

### 5. Observability & Health Probes (`/api/v1/observability`)

| Verb | Endpoint | Description | Format |
| :--- | :--- | :--- | :--- |
| `GET` | `/observability/health` | Overall system health status | JSON |
| `GET` | `/observability/liveness` | Kubernetes liveness probe | JSON |
| `GET` | `/observability/readiness` | Kubernetes readiness probe | JSON |
| `GET` | `/observability/metrics` | System & application performance metrics | JSON |
| `GET` | `/observability/prometheus` | Prometheus exposition text metrics | Text |

---

## Standard Error Codes

| Status Code | Code String | Description |
| :--- | :--- | :--- |
| `400` | `BAD_REQUEST` | Validation failure or missing parameters |
| `401` | `UNAUTHORIZED` | Expired or invalid Bearer JWT token |
| `403` | `FORBIDDEN` | Bot detected, blocked IP, or insufficient role |
| `409` | `CONFLICT` | Idempotency lock active or race condition |
| `429` | `TOO_MANY_REQUESTS` | Rate limit threshold exceeded |
| `500` | `INTERNAL_ERROR` | Server exception (logged with traceId) |
