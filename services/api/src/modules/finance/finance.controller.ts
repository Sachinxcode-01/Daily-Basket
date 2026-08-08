import { Controller, Get, Post } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { FinanceService } from './finance.service';

@ApiTags('Finance & Accounting')
@Controller('finance')
export class FinanceController {
  constructor(private readonly financeService: FinanceService) {}

  @Get('revenue')
  @ApiOperation({ summary: 'Get revenue dashboard, net profit, and order totals' })
  async getRevenueOverview() {
    return this.financeService.getRevenueOverview();
  }

  @Get('gst-report')
  @ApiOperation({ summary: 'Get GST compliance, CGST, SGST, and tax liability report' })
  async getGstReport() {
    return this.financeService.getGstReport();
  }

  @Get('vendor-payouts')
  @ApiOperation({ summary: 'Get supplier vendor payout settlement ledger' })
  async getVendorPayouts() {
    return this.financeService.getVendorPayouts();
  }

  @Get('rider-payouts')
  @ApiOperation({ summary: 'Get weekly delivery partner fleet payout ledger' })
  async getRiderPayouts() {
    return this.financeService.getRiderPayouts();
  }

  @Post('daily-closing')
  @ApiOperation({ summary: 'Execute end-of-day daily financial closing & ledger lock' })
  async processDailyClosing() {
    return this.financeService.processDailyClosing();
  }

  @Get('pnl')
  @ApiOperation({ summary: 'Get Profit & Loss (P&L) financial statement' })
  async getProfitAndLossStatement() {
    return this.financeService.getProfitAndLossStatement();
  }
}
