# API & OpenAPI Guidelines - Daily Basket

## 1. RESTful Standards
- Base API Endpoint: `/api/v1`
- JSON Payload formatting with `snake_case` or `camelCase` consistency.
- Standardized HTTP Response Envelope:
```json
{
  "success": true,
  "statusCode": 200,
  "data": {},
  "meta": {
    "timestamp": "2026-08-03T21:45:00.000Z"
  }
}
```

## 2. Error Response Format
```json
{
  "success": false,
  "statusCode": 400,
  "errorCode": "ERR_OUT_OF_STOCK",
  "message": "Requested variant is currently out of stock.",
  "timestamp": "2026-08-03T21:45:00.000Z"
}
```
