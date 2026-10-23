import { NextRequest, NextResponse } from 'next/server';
import { updateProductMemory } from '../../../../lib/products-store';

export async function POST(req: NextRequest, { params }: { params: { id: string } }) {
  const { id } = params;
  const body = await req.json();
  const newStock = Number(body.newStock) || 0;
  const backendUrl = process.env.API_BASE_URL || 'http://localhost:4000';

  try {
    const res = await fetch(`${backendUrl}/api/v1/products/${id}/update-stock`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ newStock }),
    });
    if (res.ok) {
      const data = await res.json();
      return NextResponse.json(data);
    }
  } catch {
    // Fallback
  }

  updateProductMemory(id, { stockQuantity: newStock, isAvailable: newStock > 0 });
  return NextResponse.json({
    success: true,
    data: { id, newStock, isAvailable: newStock > 0, status: 'UPDATED' },
  });
}
