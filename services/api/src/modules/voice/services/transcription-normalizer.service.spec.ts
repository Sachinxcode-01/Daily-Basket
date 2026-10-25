import { Test, TestingModule } from '@nestjs/testing';
import { TranscriptionNormalizerService } from './transcription-normalizer.service';

describe('TranscriptionNormalizerService', () => {
  let service: TranscriptionNormalizerService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [TranscriptionNormalizerService],
    }).compile();

    service = module.get<TranscriptionNormalizerService>(TranscriptionNormalizerService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should handle empty or whitespace text gracefully', () => {
    const res = service.normalize('');
    expect(res.searchQuery).toBe('');
    expect(res.cleanedText).toBe('');
  });

  it('should normalize "Find one litre of milk"', () => {
    const res = service.normalize('Find one litre of milk.');
    expect(res.searchQuery).toBe('milk');
    expect(res.extractedQuantity).toBe(1);
    expect(res.extractedUnit).toBe('1L');
  });

  it('should normalize "Search for organic bananas"', () => {
    const res = service.normalize('Search for organic bananas');
    expect(res.searchQuery).toContain('organic bananas');
    expect(res.isOrganic).toBe(true);
  });

  it('should normalize price filter "Find rice under 100 rupees"', () => {
    const res = service.normalize('Find rice under 100 rupees');
    expect(res.searchQuery).toBe('rice');
    expect(res.maxPrice).toBe(100);
  });

  it('should normalize "Show available cooking oil"', () => {
    const res = service.normalize('Show available cooking oil');
    expect(res.searchQuery).toBe('cooking oil');
  });

  it('should normalize "Find one kilogram of tomatoes"', () => {
    const res = service.normalize('Find one kilogram of tomatoes');
    expect(res.searchQuery).toBe('tomatoes');
    expect(res.extractedQuantity).toBe(1);
    expect(res.extractedUnit).toBe('1kg');
  });

  it('should normalize "Search for bread"', () => {
    const res = service.normalize('Search for bread');
    expect(res.searchQuery).toBe('bread');
  });

  it('should normalize multi-product request "Find milk and bread"', () => {
    const res = service.normalize('Find milk and bread');
    expect(res.searchQuery).toBe('milk bread');
  });
});
