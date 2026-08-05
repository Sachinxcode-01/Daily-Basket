import http from 'k6/http';
import { check, sleep, group } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 100 },   # Ramp to 100 users
    { duration: '1m', target: 500 },    # Ramp to 500 users
    { duration: '1m', target: 1000 },   # Peak 1,000 concurrent users
    { duration: '30s', target: 5000 },   # Stress spike to 5,000 users
    { duration: '30s', target: 0 },      # Cool down to 0
  ],
  thresholds: {
    http_req_duration: ['p(95)<200', 'p(99)<500'], // 95% of requests under 200ms
    http_req_failed: ['rate<0.01'],               // Less than 1% error rate
  },
};

const BASE_URL = __ENV.API_URL || 'http://localhost:4000/api/v1';

export default function () {
  group('1. Health Check & Liveness', function () {
    const res = http.get(`${BASE_URL}/health`);
    check(res, {
      'health status is 200': (r) => r.status === 200,
      'response contains status ok': (r) => r.json().status === 'ok',
    });
  });

  sleep(1);

  group('2. Product Catalog & Search', function () {
    const searchRes = http.post(
      `${BASE_URL}/search`,
      JSON.stringify({ query: 'organic milk', page: 1, limit: 10 }),
      { headers: { 'Content-Type': 'application/json' } }
    );
    check(searchRes, {
      'search status is 200': (r) => r.status === 200 || r.status === 201,
    });
  });

  sleep(1);

  group('3. Phone OTP Authentication Journey', function () {
    const reqOtpRes = http.post(
      `${BASE_URL}/auth/login-otp`,
      JSON.stringify({ phone: '+919876543210' }),
      { headers: { 'Content-Type': 'application/json' } }
    );
    check(reqOtpRes, {
      'OTP request status is 200': (r) => r.status === 200 || r.status === 201,
    });

    const verifyOtpRes = http.post(
      `${BASE_URL}/auth/verify-otp`,
      JSON.stringify({ phone: '+919876543210', otp: '123456' }),
      { headers: { 'Content-Type': 'application/json' } }
    );
    check(verifyOtpRes, {
      'OTP verify status is 200': (r) => r.status === 200 || r.status === 201,
      'has bearer token': (r) => r.json().accessToken !== undefined,
    });
  });

  sleep(2);
}
