# 🔔 Notification Subsystem Specification — Daily Basket (`docs/features/NOTIFICATIONS.md`)

This document describes the multi-channel notification engine (FCM Push Notifications, SMS OTP, Email, and In-App Feed).

---

## 1. Notification Dispatch Channels

- **SMS OTP**: Dispatches 6-digit phone verification OTPs via SMS gateway (`modules/auth`).
- **Transactional Emails**: Sends order receipts, password resets, and account alerts using Nodemailer (`modules/email`).
- **In-App Notification Feed**: Stores user alerts in database and streams unread notifications to Mobile and Web clients.
- **Async Queue Dispatch**: All heavy notifications are processed off the main HTTP thread via BullMQ (`modules/queue`).
