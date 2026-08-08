import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface RegisterFranchiseDto {
  name: string;
  companyName: string;
  gstin: string;
  franchiseOwnerId: string;
  city: string;
  commissionPercent?: number;
}

@Injectable()
export class FranchiseService {
  constructor(private readonly prisma: PrismaService) {}

  async listFranchises() {
    const franchises = await this.prisma.franchise.findMany({
      orderBy: { name: 'asc' },
    });

    if (franchises.length === 0) {
      return [
        {
          id: 'fran_01',
          name: 'Koramangala Franchise Store #02',
          companyName: 'Apex Retail Enterprises LLP',
          gstin: '29AAACA9921M1Z4',
          city: 'Bengaluru',
          commissionPercent: 8.5,
          status: 'ACTIVE',
          monthlyGrossRevenue: 1026000.0,
          monthlyCommission: 87210.0,
        },
      ];
    }
    return franchises;
  }

  async registerFranchise(dto: RegisterFranchiseDto) {
    return this.prisma.franchise.create({
      data: {
        name: dto.name,
        companyName: dto.companyName,
        gstin: dto.gstin,
        franchiseOwnerId: dto.franchiseOwnerId,
        city: dto.city,
        commissionPercent: dto.commissionPercent ?? 8.5,
        revenueShareTerms: { settlementCycle: 'WEEKLY', bankTransferDay: 'MONDAY' },
        status: 'ACTIVE',
      },
    });
  }
}
