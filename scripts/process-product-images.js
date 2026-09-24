const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const crypto = require('crypto');

const baseDir = path.resolve(__dirname, '../assets/products');
const categories = fs.readdirSync(baseDir);

console.log('--- Daily Basket Image Organizer & Deduplicator ---');
console.log('Categories found:', categories);

// Step 1: Extract all zip files and flatten any nested directories
for (const cat of categories) {
  const catPath = path.join(baseDir, cat);
  if (!fs.statSync(catPath).isDirectory()) continue;

  const items = fs.readdirSync(catPath);
  for (const item of items) {
    const itemPath = path.join(catPath, item);
    const stat = fs.statSync(itemPath);

    if (item.endsWith('.zip')) {
      console.log(`Extracting zip in [${cat}]: ${item}`);
      try {
        execSync(`tar -xf "${itemPath}" -C "${catPath}"`);
        // Remove the zip after successful extraction to keep folder clean
        fs.unlinkSync(itemPath);
        console.log(`Extracted & removed zip: ${item}`);
      } catch (err) {
        console.error(`Failed to extract ${itemPath}:`, err.message);
      }
    } else if (stat.isDirectory()) {
      // Subdirectory like "Buy Bread & Pav Online Now" -> move all files up to catPath
      console.log(`Moving files from subfolder [${cat}/${item}] to [${cat}]`);
      const subItems = fs.readdirSync(itemPath);
      for (const subItem of subItems) {
        const src = path.join(itemPath, subItem);
        const dest = path.join(catPath, subItem);
        if (fs.existsSync(dest)) {
          fs.unlinkSync(src); // duplicate filename
        } else {
          fs.renameSync(src, dest);
        }
      }
      try {
        fs.rmdirSync(itemPath);
        console.log(`Cleaned up subfolder: ${item}`);
      } catch (e) {
        // Ignored
      }
    }
  }
}

// Step 2: Hash all files, detect duplicates within and across categories
console.log('\n--- Checking for duplicates via SHA-256 ---');
const hashMap = new Map(); // hash -> { cat, file }
let totalImages = 0;
let duplicateCount = 0;
const categoryStats = {};

for (const cat of categories) {
  const catPath = path.join(baseDir, cat);
  if (!fs.statSync(catPath).isDirectory()) continue;

  categoryStats[cat] = { total: 0, removedDuplicates: 0 };
  const items = fs.readdirSync(catPath);

  for (const file of items) {
    const filePath = path.join(catPath, file);
    if (!fs.statSync(filePath).isFile()) continue;

    // Filter only images
    if (!/\.(png|jpe?g|webp|svg)$/i.test(file)) {
      continue;
    }

    totalImages++;
    categoryStats[cat].total++;

    const buffer = fs.readFileSync(filePath);
    const hash = crypto.createHash('sha256').update(buffer).digest('hex');

    if (hashMap.has(hash)) {
      const original = hashMap.get(hash);
      console.log(`Duplicate found: [${cat}/${file}] is identical to [${original.cat}/${original.file}]. Removing duplicate...`);
      fs.unlinkSync(filePath);
      duplicateCount++;
      categoryStats[cat].removedDuplicates++;
      categoryStats[cat].total--;
    } else {
      hashMap.set(hash, { cat, file });
    }
  }
}

console.log('\n--- Summary Report ---');
console.log(`Total Unique Images: ${hashMap.size}`);
console.log(`Duplicates Removed: ${duplicateCount}`);
console.log('Category breakdown:');
for (const [cat, stats] of Object.entries(categoryStats)) {
  console.log(` - ${cat}: ${stats.total} unique photos (removed ${stats.removedDuplicates} duplicates)`);
}
