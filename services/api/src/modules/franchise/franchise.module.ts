import { Module } from '@nestjs/common';
import { FranchiseService } from './franchise.service';
import { FranchiseController } from './franchise.controller';
import { PrismaModule } from '../../database/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [FranchiseService],
  controllers: [FranchiseController],
  exports: [FranchiseService],
})
export class FranchiseModule {}
