import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface PincodePostOffice {
  name: string;
  branchType: string;
  deliveryStatus: string;
  circle: string;
  district: string;
  division: string;
  region: string;
  block: string;
  state: string;
  country: string;
  pincode: string;
}

export interface PincodeLookupResponse {
  success: boolean;
  isValid: boolean;
  pincode: string;
  country: string;
  state: string;
  district: string;
  city: string;
  localities: string[];
  postOffices: PincodePostOffice[];
  isServiceable: boolean;
  serviceabilityMessage: string;
  serviceabilityBadge: 'IN_RANGE' | 'OUT_OF_RANGE';
  darkStore?: {
    id: string;
    name: string;
    distanceKm?: number;
    estimatedDeliveryMins: number;
    isOpen: boolean;
  };
  error?: string;
}

interface CacheEntry {
  data: PincodeLookupResponse;
  expiresAt: number;
}

@Injectable()
export class PincodeLookupService {
  private readonly logger = new Logger(PincodeLookupService.name);

  // In-memory cache with 24-hour TTL for postal information
  private readonly cache = new Map<string, CacheEntry>();
  private readonly CACHE_TTL_MS = 24 * 60 * 60 * 1000;

  // Single Kirana & Dark Store Serviceable PINs (Bengaluru cluster)
  public static readonly DEFAULT_SERVICEABLE_PINS = new Set([
    '560001', // MG Road / Central
    '560008', // Ulsoor / Halasuru
    '560025', // Richmond Town
    '560034', // Koramangala
    '560038', // Indiranagar
    '560075', // CV Raman Nagar
    '560095', // Koramangala Extension
    '560102', // HSR Layout Sector 2
    '560103', // Bellandur / Outer Ring Road
  ]);

  constructor(private readonly prisma: PrismaService) { }

  /**
   * Validates if a string is a standard 6-digit Indian PIN code
   */
  public isValidIndianPincode(pincode: string): boolean {
    if (!pincode || typeof pincode !== 'string') return false;
    const clean = pincode.trim();
    return /^[1-9][0-9]{5}$/.test(clean);
  }

  /**
   * Primary entry point: Look up postal details and check delivery serviceability
   */
  async lookupPincode(rawPincode: string): Promise<PincodeLookupResponse> {
    const pincode = (rawPincode || '').trim();

    // 1. Format validation
    if (!this.isValidIndianPincode(pincode)) {
      return {
        success: false,
        isValid: false,
        pincode,
        country: 'India',
        state: '',
        district: '',
        city: '',
        localities: [],
        postOffices: [],
        isServiceable: false,
        serviceabilityMessage: 'Please enter a valid 6-digit Indian PIN code (e.g. 582103 or 560038).',
        serviceabilityBadge: 'OUT_OF_RANGE',
        error: 'Invalid PIN code format. Must be 6 digits and cannot start with 0.',
      };
    }

    // 2. Check cache
    const cached = this.cache.get(pincode);
    if (cached && cached.expiresAt > Date.now()) {
      // Re-evaluate serviceability in case store zones were updated dynamically
      const isServiceable = await this.checkServiceability(pincode);
      return {
        ...cached.data,
        isServiceable,
        serviceabilityBadge: isServiceable ? 'IN_RANGE' : 'OUT_OF_RANGE',
        serviceabilityMessage: isServiceable
          ? '10-Minute Kirana Delivery Available in this area!'
          : `Currently delivery is not available in ${cached.data.district || cached.data.city || pincode}. Daily Basket operates in Bengaluru.`,
      };
    }

    // 3. Fetch from reliable India Post compatible postal service
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 10000);

      const response = await fetch(`https://api.postalpincode.in/pincode/${pincode}`, {
        signal: controller.signal,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'DailyBasket-QuickCommerce/1.0',
        },
      });
      clearTimeout(timeoutId);

      if (!response.ok) {
        throw new Error(`Postal API returned status HTTP ${response.status}`);
      }

      const json = await response.json();

      if (!Array.isArray(json) || json.length === 0) {
        return {
          success: false,
          isValid: false,
          pincode,
          country: 'India',
          state: '',
          district: '',
          city: '',
          localities: [],
          postOffices: [],
          isServiceable: false,
          serviceabilityMessage: 'No postal data found for this PIN code.',
          serviceabilityBadge: 'OUT_OF_RANGE',
          error: 'Postal service returned an empty response.',
        };
      }

      const resultObj = json[0];
      if (resultObj.Status !== 'Success' || !Array.isArray(resultObj.PostOffice) || resultObj.PostOffice.length === 0) {
        return {
          success: false,
          isValid: false,
          pincode,
          country: 'India',
          state: '',
          district: '',
          city: '',
          localities: [],
          postOffices: [],
          isServiceable: false,
          serviceabilityMessage: resultObj.Message || 'No postal records found for this PIN code.',
          serviceabilityBadge: 'OUT_OF_RANGE',
          error: resultObj.Message || 'No postal records found.',
        };
      }

      // Map raw post offices
      const postOffices: PincodePostOffice[] = resultObj.PostOffice.map((po: any) => ({
        name: po.Name || '',
        branchType: po.BranchType || '',
        deliveryStatus: po.DeliveryStatus || '',
        circle: po.Circle || '',
        district: po.District || '',
        division: po.Division || '',
        region: po.Region || '',
        block: po.Block || '',
        state: po.State || '',
        country: po.Country || 'India',
        pincode: po.Pincode || pincode,
      }));

      const primary = postOffices[0];
      const state = primary.state || '';
      const district = primary.district || '';
      const country = primary.country || 'India';

      // Pick representative city / town / village
      // Look for a Head Post Office or Sub Post Office or use district/division name
      const mainPo = postOffices.find((po) => po.branchType.includes('Head') || po.branchType.includes('Sub')) || primary;
      const city = mainPo.district || mainPo.division || mainPo.block || mainPo.name;

      // Extract unique list of locality / post office names
      const localities = Array.from(new Set(postOffices.map((po) => po.name.trim()))).filter(Boolean);

      // 4. Check delivery serviceability
      const isServiceable = await this.checkServiceability(pincode);

      const responsePayload: PincodeLookupResponse = {
        success: true,
        isValid: true,
        pincode,
        country,
        state,
        district,
        city,
        localities,
        postOffices,
        isServiceable,
        serviceabilityBadge: isServiceable ? 'IN_RANGE' : 'OUT_OF_RANGE',
        serviceabilityMessage: isServiceable
          ? '10-Minute Kirana Delivery Available in this area!'
          : `Currently delivery is not available in ${district || city || pincode}. Daily Basket operates in Bengaluru.`,
        darkStore: isServiceable
          ? {
            id: 'ds_bengaluru_hub',
            name: 'Daily Basket Express Dark Store',
            distanceKm: 1.2,
            estimatedDeliveryMins: 10,
            isOpen: true,
          }
          : undefined,
      };

      // Cache lookup result
      this.cache.set(pincode, {
        data: responsePayload,
        expiresAt: Date.now() + this.CACHE_TTL_MS,
      });

      return responsePayload;
    } catch (err: any) {
      this.logger.error(`Postal lookup failed for PIN ${pincode}: ${err?.message}`);

      // Even on API timeout/failure, don't crash.
      // Check if PIN is in our known serviceable list
      const isServiceable = await this.checkServiceability(pincode);

      return {
        success: false,
        isValid: true, // Form validation passed even if remote API had network failure
        pincode,
        country: 'India',
        state: '',
        district: '',
        city: '',
        localities: [],
        postOffices: [],
        isServiceable,
        serviceabilityBadge: isServiceable ? 'IN_RANGE' : 'OUT_OF_RANGE',
        serviceabilityMessage: isServiceable
          ? 'PIN is within Daily Basket delivery zone. Please enter remaining address details manually.'
          : 'Postal lookup service timed out or was temporarily unreachable. You may enter details manually.',
        error: err?.name === 'AbortError' ? 'Lookup request timed out. Please verify your connection.' : err?.message,
      };
    }
  }

  /**
   * Check if the PIN code is within Daily Basket's serviceable clusters
   * Separated cleanly from postal validity
   */
  public async checkServiceability(pincode: string): Promise<boolean> {
    const cleanPin = pincode.trim();

    // 1. Check default serviceable PIN set
    if (PincodeLookupService.DEFAULT_SERVICEABLE_PINS.has(cleanPin)) {
      return true;
    }

    // 2. Check active DeliveryZone records in database if Prisma is available
    try {
      const activeZone = await this.prisma.deliveryZone.findFirst({
        where: {
          isActive: true,
          pincodes: { has: cleanPin },
        },
      });
      if (activeZone) return true;
    } catch {
      // Ignore database connection issues and rely on static serviceable list
    }

    return false;
  }
}
