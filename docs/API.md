# 🔌 REST API Endpoint Directory — Daily Basket

**Base URL**: `http://localhost:4000/api/v1`  
**Swagger Interactive Specs**: `http://localhost:4000/api/docs`  
**Authentication Standard**: Bearer JWT (`Authorization: Bearer <token>`)

---

## 1. Authentication Module (`/auth`)

### `POST /auth/login-otp`
- **Description**: Request a 6-digit phone verification OTP.
- **Authentication**: None (Public).
- **Request Body**:
  ```json
  {
    "phoneNumber": "+919876543210"
  }
  ```
- **Response `200 OK`**:
  ```json
  {
    "success": true,
    "message": "OTP sent successfully",
    "expiresInSeconds": 300
  }
  ```

### `POST /auth/verify-otp`
- **Description**: Verify phone OTP PIN and receive JWT access token pair.
- **Authentication**: None (Public).
- **Request Body**:
  ```json
  {
    "phoneNumber": "+919876543210",
    "otp": "4821"
  }
  ```
- **Response `200 OK`**:
  ```json
  {
    "accessToken": "eyJhbGciOiJIUzI1Ni...",
    "refreshToken": "d9b28a1c...",
    "user": {
      "id": "u-101",
      "phoneNumber": "+919876543210",
      "fullName": "Rahul Sharma",
      "role": "CUSTOMER"
    }
  }
  ```

### `POST /auth/google`
- **Description**: Authenticate using Google OAuth token.
- **Authentication**: None (Public).
- **Request Body**:
  ```json
  {
    "idToken": "google_oauth_id_token_string"
  }
  ```

---

## 2. Products & Catalog Module (`/products`, `/categories`, `/search`)

### `GET /products/home-feed`
- **Description**: Fetch home page banners, flash deal timer, and top categories.
- **Authentication**: None (Public).
- **Response `200 OK`**:
  ```json
  {
    "banners": [{"id": "b-1", "imageUrl": "/assets/banner.png"}],
    "categories": [{"id": "cat-1", "name": "Fresh Produce", "slug": "fresh-produce"}],
    "flashDeals": [{"id": "p-101", "name": "Organic Tomatoes 1kg", "price": 32, "mrp": 45}]
  }
  ```

### `GET /products/search?query=`
- **Description**: Debounced full-text catalog product search.
- **Authentication**: None (Public).
- **Query Params**: `query=milk&categoryId=cat-1&limit=20`

---

## 3. Orders Module (`/orders`)

### `POST /orders`
- **Description**: Place a new 10-minute grocery delivery order.
- **Authentication**: Bearer JWT (`CUSTOMER`).
- **Request Body**:
  ```json
  {
    "storeId": "store-101",
    "addressId": "addr-505",
    "paymentMethod": "UPI",
    "items": [
      {
        "variantId": "var-1",
        "quantity": 2
      }
    ],
    "couponCode": "DAILY100"
  }
  ```
- **Response `201 Created`**:
  ```json
  {
    "orderId": "ord-9001",
    "orderNumber": "DB-2026-9001",
    "subtotal": 120.00,
    "deliveryFee": 0.00,
    "totalAmount": 120.00,
    "status": "CREATED",
    "estimatedArrivalMins": 10
  }
  ```

---

## 4. Payments Module (`/payments`)

### `POST /payments/initiate`
- **Description**: Create Razorpay payment intent (`rzp_order_*`).
- **Authentication**: Bearer JWT (`CUSTOMER`).

### `POST /payments/verify`
- **Description**: Verify Razorpay HMAC SHA-256 payment signature.
- **Authentication**: Bearer JWT (`CUSTOMER`).

### `POST /payments/webhook`
- **Description**: Handle Razorpay backend server webhooks.
- **Authentication**: Razorpay HMAC Signature Header (`X-Razorpay-Signature`).

---

## 5. Delivery Telemetry (`/delivery`)

### `GET /delivery/track/:orderId`
- **Description**: Fetch live rider GPS coordinates, current status, and ETA.
- **Authentication**: Bearer JWT (`CUSTOMER`).
