#!/bin/bash
# Compress all images in images/ folder for web
# Usage: ./compress.sh
# Drop originals in images/originals/, compressed versions go to images/

ORIGINALS="images/originals"
OUTPUT="images"
MAX_WIDTH=1440
QUALITY=85

mkdir -p "$ORIGINALS"

echo "🔵 Compressing images..."

for file in "$ORIGINALS"/*.{jpg,jpeg,png,JPG,JPEG,PNG,heic,HEIC}; do
  [ -f "$file" ] || continue

  filename=$(basename "$file")
  # Normalize extension to .jpg
  output_name="${filename%.*}.jpg"
  output_path="$OUTPUT/$output_name"

  echo "  → $filename"

  # Resize if wider than MAX_WIDTH, convert to JPEG, compress
  sips --resampleWidth $MAX_WIDTH "$file" --out "/tmp/compress_temp.jpg" 2>/dev/null
  sips -s format jpeg -s formatOptions $QUALITY "/tmp/compress_temp.jpg" --out "$output_path" 2>/dev/null

  # Show size reduction
  original_size=$(stat -f%z "$file")
  compressed_size=$(stat -f%z "$output_path")
  echo "    ${original_size} → ${compressed_size} bytes"
done

rm -f /tmp/compress_temp.jpg

echo ""
echo "✅ Done. Compressed images in $OUTPUT/"
echo "   Now: git add images/ && git commit -m 'Add images' && git push"
