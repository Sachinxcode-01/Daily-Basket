import { Module, Global } from '@nestjs/common';
import { QueueProcessor } from './queue.processor';

@Global()
@Module({
  providers: [QueueProcessor],
  exports: [QueueProcessor],
})
export class QueueModule {}
