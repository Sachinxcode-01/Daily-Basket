import { Controller, Get, Post, Body, UseGuards } from '@nestjs/common';
import { FranchiseService, RegisterFranchiseDto } from './franchise.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('api/franchise')
export class FranchiseController {
  constructor(private readonly franchiseService: FranchiseService) {}

  @Get()
  async listFranchises() {
    return this.franchiseService.listFranchises();
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.BUSINESS_OWNER, Role.SUPER_ADMIN)
  async registerFranchise(@Body() dto: RegisterFranchiseDto) {
    return this.franchiseService.registerFranchise(dto);
  }
}
