import { NextRequest, NextResponse } from 'next/server';
import { deleteProductMemory, updateProductMemory } from '../route';
import catalogJson from '@daily-basket/shared-types/src/products_catalog.json';

export async function GET(req: NextRequest, { params }: { params: { id: string } }) {
  const { id } = params;
  const backendUrl = process.env.API_BASE_URL || 'http://localhost:4000';

  try {
    const res = await fetch(`${backendUrl}/api/v1/products/${id}`, {
      headers: { 'Content-Type': 'application/json' },
      cache: 'no-store',
    });
    if (res.ok) {
      const data = await res.json();
      return NextResponse.json(data);
    }
  } catch {
    // Fallback
  }

  const raw: any[] = Object.values(catalogJson as Record<string, any[]>).flat();
  const match = raw.find((p) => p.id === id || p.name?.toLowerCase().includes(id.toLowerCase()));
  if (!match) {
    return NextResponse.json({ success: false, message: 'Product not found' }, { status: 404 });
  }

  const price = Number(match.price) || 0;
  const mrp = Number(match.mrp) || price;
  const webImg = match.image?.startsWith('assets/') ? `/${match.image.replace(/^assets\//, '')}` : match.image;

  return NextResponse.json({
    success: true,
    data: {
      id: match.id,
      name: match.name,
      slug: match.id,
      brand: (match.brand || 'Daily Basket').toUpperCase(),
      sku: `SKU-${match.id.replace('prod_', '').toUpperCase()}`,
      description: `${match.name}. Quality checked fresh essentials.`,
      images: [webImg || '/images/daily_basket_logo.png'],
      category: {
        id: match.categorySlug || 'produce',
        name: match.category || match.sub || 'Produce',
        slug: match.categorySlug || 'produce',
      },
      variants: [
        {
          id: `var_${match.id}`,
          unitName: match.unit || match.subtitle || '1 unit',
          price,
          mrp,
          sku: `SKU-${match.id.replace('prod_', '').toUpperCase()}`,
          isAvailable: match.inStock ?? true,
          stockQuantity: 150,
        },
      ],
    },
  });
}

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
  const { id } = params;
  const body = await req.json();
  const backendUrl = process.env.API_BASE_URL || 'http://localhost:4000';

  try {
    const res = await fetch(`${backendUrl}/api/v1/products/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    if (res.ok) {
      const data = await res.json();
      return NextResponse.json(data);
    }
  } catch {
    // Fallback
  }

  updateProductMemory(id, body);
  return NextResponse.json({
    success: true,
    message: 'Product updated successfully',
    data: { id, ...body },
  });
}

export async function DELETE(req: NextRequest, { params }: { params: { id: string } }) {
  const { id } = params;
  const backendUrl = process.env.API_BASE_URL || 'http://localhost:4000';

  try {
    const res = await fetch(`${backendUrl}/api/v1/products/${id}`, {
      method: 'DELETE',
    });
    if (res.ok) {
      const data = await res.json();
      return NextResponse.json(data);
    }
  } catch {
    // Fallback
  }

  deleteProductMemory(id);
  return NextResponse.json({
    success: true,
    message: `Product ${id} deleted successfully`,
    id,
  });
}
