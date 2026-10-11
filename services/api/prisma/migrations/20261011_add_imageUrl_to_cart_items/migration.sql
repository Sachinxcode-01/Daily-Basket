-- Migration: add_imageUrl_to_cart_items
-- Added optional imageUrl column to cart_items table so product images
-- are persisted with each cart item and correctly displayed in the mobile app.

ALTER TABLE "cart_items" ADD COLUMN "imageUrl" TEXT;
