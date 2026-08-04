import { Controller, Get, Post, Request } from '@nestjs/common';
import { ImpactService } from './impact.service';

@Controller('impact')
export class ImpactController {
  constructor(private readonly impactService: ImpactService) {}

  @Get('dashboard')
  async getDashboard(@Request() req: any) {
    const userId = req.user?.id || 'demo_user_id';
    return this.impactService.getDashboard(userId);
  }

  @Get('history')
  async getHistory(@Request() req: any) {
    const userId = req.user?.id || 'demo_user_id';
    return this.impactService.getHistory(userId);
  }

  @Get('badges')
  async getBadges(@Request() req: any) {
    const userId = req.user?.id || 'demo_user_id';
    return this.impactService.getBadges(userId);
  }

  @Get('rewards')
  async getRewards(@Request() req: any) {
    const userId = req.user?.id || 'demo_user_id';
    return this.impactService.getRewards(userId);
  }

  @Post('recalculate')
  async recalculate(@Request() req: any) {
    const userId = req.user?.id || 'demo_user_id';
    return this.impactService.recalculate(userId);
  }
}
