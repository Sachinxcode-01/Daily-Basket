import { NextRequest, NextResponse } from 'next/server';
import catalogJson from '@daily-basket/shared-types/src/products_catalog.json';

// In-memory catalog overlay for standalone Next.js admin server mode
let memoryProducts: any[] = [];
let deletedProductIds = new Set<string>();
let productOverrides = new Map<string, any>();

function initCatalog() {
  if (memoryProducts.length === 0) {
    const raw: any[] = Object.values(catalogJson as Record<string, any[]>).flat();
    memoryProducts = raw.map((p, idx) => {
      const price = Number(p.price) || 0;
      const mrp = Number(p.mrp) || price;
      const webImg = p.image?.startsWith('assets/') ? `/${p.image.replace(/^assets\//, '')}` : p.image;
      return {
        id: p.id,
        name: p.name,
        slug: p.id,
        brand: (p.brand || 'Daily Basket').toUpperCase(),
        sku: `SKU-${p.id.replace('prod_', '').toUpperCase()}`,
        category: {
          id: p.categorySlug || 'produce',
          name: p.category || p.sub || 'Produce',
          slug: p.categorySlug || 'produce',
        },
        description: `${p.name}. Quality checked fresh essentials.`,
        images: [webImg || '/images/daily_basket_logo.png'],
        variants: [
          {
            id: `var_${p.id}`,
            unitName: p.unit || p.subtitle || '1 unit',
            price,
            mrp,
            sku: `SKU-${p.id.replace('prod_', '').toUpperCase()}`,
            isAvailable: p.inStock ?? true,
            stockQuantity: 250 - (idx % 15) * 5,
          },
        ],
      };
    });
  }
}

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

  initCatalog();
  let list = memoryProducts
    .filter((p) => !deletedProductIds.has(p.id))
    .map((p) => {
      const override = productOverrides.get(p.id);
      if (!override) return p;
      return {
        ...p,
        ...override,
        variants: p.variants.map((v: any) => ({
          ...v,
          ...(override.price !== undefined && { price: override.price }),
          ...(override.mrp !== undefined && { mrp: override.mrp }),
          ...(override.unitName !== undefined && { unitName: override.unitName }),
          ...(override.stockQuantity !== undefined && {
            stockQuantity: override.stockQuantity,
            isAvailable: override.stockQuantity > 0,
          }),
        })),
      };
    });

  if (categoryId && categoryId !== 'All') {
    const cleanCat = categoryId.toLowerCase();
    list = list.filter(
      (p) =>
        p.category?.name?.toLowerCase().includes(cleanCat) ||
        p.category?.slug?.toLowerCase() === cleanCat
    );
  }

  if (query) {
    const q = query.toLowerCase();
    list = list.filter(
      (p) =>
        p.name.toLowerCase().includes(q) ||
        p.brand.toLowerCase().includes(q) ||
        p.sku.toLowerCase().includes(q)
    );
  }

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

  memoryProducts.unshift(newProduct);
  return NextResponse.json({ success: true, data: newProduct });
}

// Export memory mutations for sub-routes
export function deleteProductMemory(id: string) {
  deletedProductIds.add(id);
}

export function updateProductMemory(id: string, updates: any) {
  const current = productOverrides.get(id) || {};
  productOverrides.set(id, { ...current, ...updates });
}
