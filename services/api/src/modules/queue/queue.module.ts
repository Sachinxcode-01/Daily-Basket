import { Module, Global } from '@nestjs/common';
import { QueueProcessor } from './queue.processor';
import { EmailModule } from '../email/email.module';

@Global()
@Module({
  imports: [EmailModule],
  providers: [QueueProcessor],
  exports: [QueueProcessor],
})
export class QueueModule {}
