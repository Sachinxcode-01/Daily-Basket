import { Injectable, Logger, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface ProductValidationResult {
  isValid: boolean;
  errors: string[];
  warnings: string[];
  sanitizedData?: any;
}

export interface CatalogQualityReport {
  totalProducts: number;
  totalVariants: number;
  qualityScorePercent: number;
  brokenImagesCount: number;
  duplicateSkusCount: number;
  duplicateProductsCount: number;
  pricingAnomaliesCount: number;
  missingDescriptionCount: number;
  missingBrandCount: number;
  issues: Array<{
    productId?: string;
    productName?: string;
    type: 'BROKEN_IMAGE' | 'DUPLICATE_SKU' | 'DUPLICATE_PRODUCT' | 'PRICE_ANOMALY' | 'MISSING_BRAND' | 'MISSING_CATEGORY';
    message: string;
    severity: 'HIGH' | 'MEDIUM' | 'LOW';
  }>;
  scannedAt: string;
}

@Injectable()
export class ProductValidatorService {
  private readonly logger = new Logger(ProductValidatorService.name);

  // Reliable, high-resolution SVG/WebP fallback placeholder for grocery products
  public static readonly FALLBACK_IMAGE_URL = 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80';

  constructor(private prisma: PrismaService) {}

  /**
   * Validate a product input before creation or updating
   */
  async validateProduct(data: {
    name: string;
    brand?: string;
    categoryId: string;
    description?: string;
    images?: string[];
    variants?: Array<{
      unitName: string;
      price: number;
      mrp: number;
      sku?: string;
      stockQuantity?: number;
    }>;
  }, excludeProductId?: string): Promise<ProductValidationResult> {
    const errors: string[] = [];
    const warnings: string[] = [];

    // 1. Name validation
    if (!data.name || data.name.trim().length < 2) {
      errors.push('Product name must be at least 2 characters long.');
    }

    // 2. Category check
    if (!data.categoryId) {
      errors.push('Category ID is mandatory.');
    } else {
      const category = await this.prisma.category.findUnique({
        where: { id: data.categoryId },
      });
      if (!category) {
        errors.push(`Category with ID "${data.categoryId}" does not exist.`);
      }
    }

    // 3. Brand sanitization
    const sanitizedBrand = data.brand?.trim() || 'Daily Basket Select';
    if (!data.brand || data.brand.trim() === '') {
      warnings.push('Brand was missing; defaulted to "Daily Basket Select".');
    }

    // 4. Image validation & fallback assignment
    let sanitizedImages = data.images && data.images.length > 0
      ? data.images.filter((img) => typeof img === 'string' && img.trim().length > 0)
      : [];

    if (sanitizedImages.length === 0) {
      warnings.push('No product images supplied; fallback placeholder applied.');
      sanitizedImages = [ProductValidatorService.FALLBACK_IMAGE_URL];
    } else {
      // Check for obviously malformed image URLs
      sanitizedImages = sanitizedImages.map((img) => {
        if (!img.startsWith('http://') && !img.startsWith('https://') && !img.startsWith('/') && !img.startsWith('assets/')) {
          warnings.push(`Image path "${img}" was normalized.`);
          return `/${img.replace(/^\\+|^\/+/, '')}`;
        }
        return img;
      });
    }

    // 5. Duplicate product prevention check
    const normalizedName = data.name.trim().toLowerCase();
    const existingProducts = await this.prisma.product.findMany({
      where: {
        name: { equals: data.name.trim(), mode: 'insensitive' },
        brand: { equals: sanitizedBrand, mode: 'insensitive' },
        ...(excludeProductId ? { id: { not: excludeProductId } } : {}),
      },
      include: { variants: true },
    });

    if (existingProducts.length > 0) {
      errors.push(
        `Duplicate product detected: A product named "${data.name}" by brand "${sanitizedBrand}" already exists in the catalog.`,
      );
    }

    // 6. Variants and Pricing validation
    const sanitizedVariants = [];
    if (!data.variants || data.variants.length === 0) {
      errors.push('A product must contain at least one variant with pricing and unit.');
    } else {
      const seenSkusInPayload = new Set<string>();

      for (let i = 0; i < data.variants.length; i++) {
        const v = data.variants[i];
        const vIndex = i + 1;

        if (!v.unitName || v.unitName.trim().length === 0) {
          errors.push(`Variant #${vIndex}: Unit/weight name (e.g. '500g', '1 kg') is required.`);
        }

        const price = Number(v.price);
        const mrp = Number(v.mrp);

        if (isNaN(price) || price <= 0) {
          errors.push(`Variant #${vIndex}: Selling price must be greater than ₹0.`);
        }

        if (isNaN(mrp) || mrp <= 0) {
          errors.push(`Variant #${vIndex}: MRP must be greater than ₹0.`);
        }

        if (price > mrp) {
          errors.push(`Variant #${vIndex}: Selling price (₹${price}) cannot exceed MRP (₹${mrp}).`);
        }

        // Generate or check SKU
        let sku = v.sku?.trim();
        if (!sku) {
          const slugPart = data.name.toLowerCase().replace(/[^a-z0-9]+/g, '_').substring(0, 10);
          const unitPart = (v.unitName || 'std').toLowerCase().replace(/[^a-z0-9]+/g, '');
          sku = `DB_${slugPart}_${unitPart}_${Date.now().toString().slice(-4)}`;
        }

        if (seenSkusInPayload.has(sku)) {
          errors.push(`Variant #${vIndex}: Duplicate SKU "${sku}" within the same product payload.`);
        } else {
          seenSkusInPayload.add(sku);
        }

        // Check SKU uniqueness in database
        const existingSku = await this.prisma.productVariant.findUnique({
          where: { sku },
        });

        if (existingSku) {
          errors.push(`Variant #${vIndex}: SKU "${sku}" already exists in the database. Every SKU must be globally unique.`);
        }

        sanitizedVariants.push({
          ...v,
          unitName: v.unitName.trim(),
          price,
          mrp,
          sku,
          stockQuantity: v.stockQuantity !== undefined ? Math.max(0, Number(v.stockQuantity)) : 50,
        });
      }
    }

    return {
      isValid: errors.length === 0,
      errors,
      warnings,
      sanitizedData: errors.length === 0 ? {
        name: data.name.trim(),
        brand: sanitizedBrand,
        categoryId: data.categoryId,
        description: data.description?.trim() || `${data.name.trim()} - Premium quality grocery delivered fresh by Daily Basket.`,
        images: sanitizedImages,
        variants: sanitizedVariants,
      } : undefined,
    };
  }

  /**
   * Complete Catalog Quality Audit Engine
   * Audits all products, images, SKUs, and pricing anomalies.
   */
  async auditEntireCatalog(): Promise<CatalogQualityReport> {
    this.logger.log('🔍 Executing comprehensive catalog quality audit...');

    const products = await this.prisma.product.findMany({
      include: {
        variants: {
          include: { inventories: true },
        },
        category: true,
      },
    });

    const issues: CatalogQualityReport['issues'] = [];
    const seenSkus = new Map<string, string>(); // sku -> productId
    const seenProductKeys = new Map<string, string>(); // name+brand -> productId

    let brokenImagesCount = 0;
    let duplicateSkusCount = 0;
    let duplicateProductsCount = 0;
    let pricingAnomaliesCount = 0;
    let missingDescriptionCount = 0;
    let missingBrandCount = 0;
    let totalVariants = 0;

    for (const p of products) {
      // 1. Image Check
      if (!p.images || p.images.length === 0 || p.images.every((img) => !img || img.trim() === '')) {
        brokenImagesCount++;
        issues.push({
          productId: p.id,
          productName: p.name,
          type: 'BROKEN_IMAGE',
          message: 'Product has no valid images attached.',
          severity: 'HIGH',
        });
      } else {
        for (const img of p.images) {
          if (
            !img.startsWith('http://') &&
            !img.startsWith('https://') &&
            !img.startsWith('/') &&
            !img.startsWith('assets/')
          ) {
            brokenImagesCount++;
            issues.push({
              productId: p.id,
              productName: p.name,
              type: 'BROKEN_IMAGE',
              message: `Malformed image path: "${img}"`,
              severity: 'LOW',
            });
            break;
          }
        }
      }

      // 2. Duplicate Product check (normalized name + brand)
      const brandClean = (p.brand || 'Daily Basket Select').trim().toLowerCase();
      const nameClean = p.name.trim().toLowerCase();
      const productKey = `${nameClean}:::${brandClean}`;

      if (seenProductKeys.has(productKey)) {
        duplicateProductsCount++;
        issues.push({
          productId: p.id,
          productName: p.name,
          type: 'DUPLICATE_PRODUCT',
          message: `Product duplicates another product (ID: ${seenProductKeys.get(productKey)}) with identical name and brand.`,
          severity: 'HIGH',
        });
      } else {
        seenProductKeys.set(productKey, p.id);
      }

      // 3. Brand & Description check
      if (!p.brand || p.brand.trim() === '') {
        missingBrandCount++;
        issues.push({
          productId: p.id,
          productName: p.name,
          type: 'MISSING_BRAND',
          message: 'Product has no brand set.',
          severity: 'MEDIUM',
        });
      }

      if (!p.description || p.description.trim().length < 10) {
        missingDescriptionCount++;
      }

      // 4. Variants & Pricing audit
      for (const v of p.variants) {
        totalVariants++;

        // Duplicate SKU audit
        if (seenSkus.has(v.sku)) {
          duplicateSkusCount++;
          issues.push({
            productId: p.id,
            productName: p.name,
            type: 'DUPLICATE_SKU',
            message: `SKU "${v.sku}" is shared by multiple variants (first seen on product ${seenSkus.get(v.sku)}).`,
            severity: 'HIGH',
          });
        } else {
          seenSkus.set(v.sku, p.id);
        }

        // Pricing check: price > mrp or non-positive
        if (v.price > v.mrp) {
          pricingAnomaliesCount++;
          issues.push({
            productId: p.id,
            productName: p.name,
            type: 'PRICE_ANOMALY',
            message: `Selling price (₹${v.price}) exceeds MRP (₹${v.mrp}) for variant ${v.unitName}.`,
            severity: 'HIGH',
          });
        } else if (v.price <= 0 || v.mrp <= 0) {
          pricingAnomaliesCount++;
          issues.push({
            productId: p.id,
            productName: p.name,
            type: 'PRICE_ANOMALY',
            message: `Selling price or MRP is non-positive (Price: ₹${v.price}, MRP: ₹${v.mrp}).`,
            severity: 'HIGH',
          });
        }
      }
    }

    const totalDeductions =
      (brokenImagesCount * 2) +
      (duplicateSkusCount * 5) +
      (duplicateProductsCount * 5) +
      (pricingAnomaliesCount * 5) +
      (missingBrandCount * 1);

    const maxScore = 100;
    const qualityScorePercent = Math.max(0, Math.min(100, Math.round(maxScore - (totalDeductions / Math.max(1, products.length)) * 10)));

    return {
      totalProducts: products.length,
      totalVariants,
      qualityScorePercent,
      brokenImagesCount,
      duplicateSkusCount,
      duplicateProductsCount,
      pricingAnomaliesCount,
      missingDescriptionCount,
      missingBrandCount,
      issues: issues.slice(0, 100), // top 100 most critical issues
      scannedAt: new Date().toISOString(),
    };
  }

  /**
   * Auto-fix catalog quality issues:
   * 1. Applies fallback images to broken/missing image arrays
   * 2. Fixes inverted pricing (mrp < price)
   * 3. Sets default brand to missing brand fields
   */
  async autoFixCatalogQuality(): Promise<{
    fixedImagesCount: number;
    fixedBrandsCount: number;
    fixedPricesCount: number;
  }> {
    this.logger.log('🛠️ Auto-fixing catalog quality anomalies...');

    let fixedImagesCount = 0;
    let fixedBrandsCount = 0;
    let fixedPricesCount = 0;

    const products = await this.prisma.product.findMany({
      include: { variants: true },
    });

    for (const p of products) {
      const updates: any = {};

      if (!p.images || p.images.length === 0) {
        updates.images = [ProductValidatorService.FALLBACK_IMAGE_URL];
        fixedImagesCount++;
      }

      if (!p.brand || p.brand.trim() === '') {
        updates.brand = 'Daily Basket Select';
        fixedBrandsCount++;
      }

      if (Object.keys(updates).length > 0) {
        await this.prisma.product.update({
          where: { id: p.id },
          data: updates,
        });
      }

      for (const v of p.variants) {
        if (v.price > v.mrp) {
          // Swap or set mrp = price
          await this.prisma.productVariant.update({
            where: { id: v.id },
            data: { mrp: Math.round(v.price * 1.15) },
          });
          fixedPricesCount++;
        }
      }
    }

    return {
      fixedImagesCount,
      fixedBrandsCount,
      fixedPricesCount,
    };
  }
}
