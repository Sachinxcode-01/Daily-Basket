# 📩 BullMQ Queue Architecture (`services/api/src/modules/queue`)

Daily Basket uses **BullMQ 5** (`modules/queue`) backed by Redis to handle background job processing and asynchronous workflows.

---

## 1. Queue Processors & Job Types

- **`notifications-queue`**: Dispatches push notifications, SMS alerts, and order confirmation emails via `queue.processor.ts`.
- **`analytics-queue`**: Aggregates dark store sales KPIs, popular items, and customer satisfaction metrics asynchronously.
- **`inventory-queue`**: Re-evaluates stock levels and sends back-in-stock alerts to subscribed users.
