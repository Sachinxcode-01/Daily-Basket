# 💬 WebSocket Event Dictionary — Daily Basket

This document lists the WebSocket events broadcast over Socket.IO.

---

## 1. Client-to-Server Events

| Event Name | Payload Schema | Description |
| :--- | :--- | :--- |
| `subscribe:order` | `{ "orderId": "ord-101" }` | Customer app joins order live update room |
| `subscribe:store` | `{ "storeId": "store-505" }` | Admin app joins dark store queue room |
| `rider:telemetry` | `{ "latitude": 15.432, "longitude": 75.632 }` | Delivery partner app sends current GPS coordinates |

---

## 2. Server-to-Client Events

| Event Name | Payload Schema | Description |
| :--- | :--- | :--- |
| `order:status_change` | `{ "orderId": "ord-101", "status": "PACKING" }` | Emitted when order status changes |
| `order:location_update` | `{ "orderId": "ord-101", "lat": 15.43, "lng": 75.63, "etaMins": 4 }` | Live GPS location broadcast |
| `store:new_order` | `{ "order": { ... } }` | Emitted to Dark Store Admin on new order placement |
