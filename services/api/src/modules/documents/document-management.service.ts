import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface CreateBusinessDocumentDto {
  title: string;
  type: string; // INVOICE, PURCHASE_BILL, GST_DOC, VENDOR_DOC, DELIVERY_PROOF, REFUND_RECEIPT
  fileUrl: string;
  fileSize?: string;
  uploadedBy?: string;
}

@Injectable()
export class DocumentManagementService {
  constructor(private readonly prisma: PrismaService) {}

  async listDocuments(type?: string) {
    const docs = await this.prisma.businessDocument.findMany({
      where: type ? { type } : undefined,
      orderBy: { createdAt: 'desc' },
    });

    if (docs.length === 0) {
      return [
        {
          id: 'doc_01',
          title: 'GST Return Filing - July 2026',
          type: 'GST_DOC',
          fileUrl: 'https://cdn.dailybasket.com/docs/gst_jul_2026.pdf',
          fileSize: '1.2 MB',
          uploadedBy: 'FINANCE_MANAGER',
          createdAt: new Date(),
        },
        {
          id: 'doc_02',
          title: 'Amul Dairy Purchase Bill #INV-9821',
          type: 'PURCHASE_BILL',
          fileUrl: 'https://cdn.dailybasket.com/docs/inv_9821.pdf',
          fileSize: '480 KB',
          uploadedBy: 'STORE_OWNER',
          createdAt: new Date(),
        },
        {
          id: 'doc_03',
          title: 'Vendor License Agreement - ITC',
          type: 'VENDOR_DOC',
          fileUrl: 'https://cdn.dailybasket.com/docs/itc_agreement.pdf',
          fileSize: '3.4 MB',
          uploadedBy: 'BUSINESS_OWNER',
          createdAt: new Date(),
        },
      ];
    }
    return docs;
  }

  async uploadDocument(dto: CreateBusinessDocumentDto) {
    return this.prisma.businessDocument.create({
      data: {
        title: dto.title,
        type: dto.type,
        fileUrl: dto.fileUrl,
        fileSize: dto.fileSize ?? '350 KB',
        uploadedBy: dto.uploadedBy ?? 'STORE_OWNER',
      },
    });
  }
}
