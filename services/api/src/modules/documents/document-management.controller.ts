import { Controller, Get, Post, Body, Query, UseGuards } from '@nestjs/common';
import { DocumentManagementService, CreateBusinessDocumentDto } from './document-management.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('api/documents')
export class DocumentManagementController {
  constructor(private readonly docService: DocumentManagementService) {}

  @Get()
  async listDocuments(@Query('type') type?: string) {
    return this.docService.listDocuments(type);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.STORE_MANAGER, Role.FINANCE_MANAGER, Role.BUSINESS_OWNER)
  async uploadDocument(@Body() dto: CreateBusinessDocumentDto) {
    return this.docService.uploadDocument(dto);
  }
}
