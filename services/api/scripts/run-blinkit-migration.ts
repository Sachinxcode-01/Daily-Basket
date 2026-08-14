import { NestFactory } from '@nestjs/core';
import { AppModule } from '../src/app.module';
import { BlinkitMigrationService } from '../src/modules/products/blinkit-migration.service';

async function bootstrap() {
  console.log('🚀 Initializing Blinkit Migration Standalone CLI Runner...');
  const app = await NestFactory.createApplicationContext(AppModule, { logger: ['log', 'warn', 'error'] });

  const migrationService = app.get(BlinkitMigrationService);

  console.log('\n--- Step 1: Executing Database Product Reset (Delete All Products) ---');
  const wipeResult = await migrationService.deleteAllProducts();
  console.log('Wipe Result:', wipeResult);

  console.log('\n--- Step 2: Executing Blinkit Migration & AI Data Enrichment ---');
  const report = await migrationService.runMigration();

  console.log('\n======================================================');
  console.log('📊 MIGRATION & ENRICHMENT REPORT SUMMARY');
  console.log('======================================================');
  console.log(`Total Products Processed: ${report.totalImported}`);
  console.log(`New Products Created:    ${report.newProducts}`);
  console.log(`Updated Products:        ${report.updatedProducts}`);
  console.log(`Duplicate Products:      ${report.duplicateProducts}`);
  console.log(`Failed Imports:          ${report.failedImports}`);
  console.log(`Execution Time:          ${(report.processingTimeMs / 1000).toFixed(2)} seconds`);
  console.log('\nCategory Breakdown:');
  Object.entries(report.categoryBreakdown).forEach(([cat, count]) => {
    console.log(`  - ${cat}: ${count} products`);
  });
  console.log('======================================================\n');

  await app.close();
  process.exit(0);
}

bootstrap().catch((err) => {
  console.error('Fatal error during migration:', err);
  process.exit(1);
});
