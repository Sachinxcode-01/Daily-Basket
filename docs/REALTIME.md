# ⚡ Real-Time Engine & WebSockets — Daily Basket

Daily Basket uses **Socket.IO 4** WebSockets to power live order progress tracking, continuous delivery partner GPS telemetry, and dark store admin dispatch streams.

---

## 1. WebSockets Gateway Architecture

- **`EventsGateway` (`modules/events/events.gateway.ts`)**: Handles core WebSocket connections, authentication, room join/leave requests, and order telemetry streaming.
- **`SupportGateway` (`modules/support/support.gateway.ts`)**: Handles live customer support chat sessions and executive messaging.

---

## 2. Dynamic Room Partitioning

WebSockets use room partitioning to isolate updates:
- `order:<orderId>`: Subscribed by customer app to receive live order status updates and rider GPS coordinates.
- `store:<storeId>`: Subscribed by Dark Store Admin Dashboard to stream incoming orders in real time.
- `rider:<riderId>`: Subscribed by assigned delivery partner for new delivery alerts.
