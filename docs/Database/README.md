# Database Specification & Entity Relationship Diagram - Daily Basket

## 1. Primary Relational Schema (PostgreSQL via Prisma ORM)

The primary database schema consists of 16 normalized tables:

1. **`stores`**: Kirana store metadata, geographic coordinates, opening hours, active status.
2. **`users`**: Customer, Admin, Store Manager, and Delivery Partner accounts.
3. **`addresses`**: User delivery locations with latitude/longitude coordinates.
4. **`categories`**: Product taxonomy (hierarchy, icons, sort order).
5. **`products`**: Master product details, images, description, organic tag.
6. **`product_variants`**: SKUs, pricing (MRP vs selling price), unit weights.
7. **`inventories`**: Real-time stock counts per store variant with reserved stock locking.
8. **`orders`**: Master orders, billing summary, delivery status state machine.
9. **`order_items`**: Snapshot of ordered variants and prices.
10. **`payments`**: Razorpay gateway transactions, UPI references, payment status.
11. **`delivery_assignments`**: Driver allocations, live GPS tracking logs, fulfillment timestamps.
12. **`coupons`**: Discount rules, minimum order amounts, max usages.
13. **`wallets`**: User store wallet balances (Daily Basket Pay).
14. **`wallet_transactions`**: Passbook log of wallet credits/debits.
15. **`reviews`**: Ratings and feedback for products.
16. **`notifications`**: FCM push notification history and alert logs.
