# ⚙️ Environment Variables Matrix — Daily Basket

This document specifies all environment variables required by `services/api/.env`.

---

## 1. Environment Variable Specifications

| Variable Name | Description | Example Value | Required |
| :--- | :--- | :--- | :---: |
| `PORT` | API Gateway HTTP Listening Port | `4000` | Yes |
| `NODE_ENV` | Environment mode (`development` / `production`) | `development` | Yes |
| `DATABASE_URL` | PostgreSQL connection URI | `postgresql://postgres:postgres@localhost:5432/daily_basket?schema=public` | Yes |
| `REDIS_HOST` | Redis host address | `localhost` | Yes |
| `REDIS_PORT` | Redis port | `6379` | Yes |
| `JWT_SECRET` | Secret key for signing access tokens | `super-secret-jwt-key` | Yes |
| `RAZORPAY_KEY_ID` | Razorpay API Key ID | `rzp_test_xxxx` | Yes |
| `RAZORPAY_KEY_SECRET` | Razorpay HMAC Webhook Secret | `razorpay_secret_key` | Yes |
| `GEMINI_API_KEY` | Google Gemini AI API key | `AIzaSy...` | Optional |
