import { NextRequest, NextResponse } from 'next/server';
import {
  addProductMemory,
  getFilteredProducts,
  initCatalog,
} from '../../lib/products-store';

export async function GET(req: NextRequest) {
  // Try forwarding to backend first
  const backendUrl = process.env.API_BASE_URL || 'http://localhost:4000';
  const { searchParams } = new URL(req.url);
  const categoryId = searchParams.get('categoryId');
  const query = searchParams.get('query');

  try {
    const queryStr = searchParams.toString() ? `?${searchParams.toString()}` : '';
    const res = await fetch(`${backendUrl}/api/v1/products${queryStr}`, {
      headers: { 'Content-Type': 'application/json' },
      cache: 'no-store',
    });
    if (res.ok) {
      const data = await res.json();
      return NextResponse.json(data);
    }
  } catch {
    // Backend offline, fallback to in-memory Next.js store
  }

  const list = getFilteredProducts(categoryId, query);
  return NextResponse.json({ success: true, data: list });
}

export async function POST(req: NextRequest) {
  const body = await req.json();

  // Try forwarding to backend
  const backendUrl = process.env.API_BASE_URL || 'http://localhost:4000';
  try {
    const res = await fetch(`${backendUrl}/api/v1/products`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    if (res.ok) {
      const data = await res.json();
      return NextResponse.json(data);
    }
  } catch {
    // Fallback below
  }

  initCatalog();
  const id = `prod_${Date.now()}`;
  const price = Number(body.price) || 99;
  const mrp = Number(body.mrp) || Math.round(price * 1.25);
  const stock = Number(body.stockQuantity) ?? 100;
  const newProduct = {
    id,
    name: body.name,
    slug: id,
    brand: (body.brand || 'Daily Basket').toUpperCase(),
    sku: body.sku || `SKU-${id.replace('prod_', '')}`,
    category: {
      id: body.categoryId || 'produce',
      name: body.category || 'Produce',
      slug: (body.category || 'produce').toLowerCase().replace(/[^a-z0-9]+/g, '-'),
    },
    description: body.description || `${body.name}. Premium fresh product.`,
    images: body.images || [body.image || '/images/daily_basket_logo.png'],
    variants: [
      {
        id: `var_${id}`,
        unitName: body.unitName || body.unit || '1 unit',
        price,
        mrp,
        sku: body.sku || `SKU-${id.replace('prod_', '')}`,
        isAvailable: stock > 0,
        stockQuantity: stock,
      },
    ],
  };

  addProductMemory(newProduct);
  return NextResponse.json({ success: true, data: newProduct });
}
