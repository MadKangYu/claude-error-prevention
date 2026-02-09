#!/bin/bash
# patch-opencode.sh — Rebuild and deploy patched OpenCode binary
# Run after: npm update opencode-ai
# Source: ~/opencode/opencode-source (branch: dev)
set -euo pipefail

BINARY_DIR="$HOME/.npm-global/lib/node_modules/opencode-ai/node_modules/opencode-darwin-arm64/bin"
SOURCE_DIR="$HOME/opencode/opencode-source"
BUILD_OUTPUT="$SOURCE_DIR/packages/opencode/dist/opencode"

echo "=== OpenCode Patch Builder ==="

# 1. Verify source exists
if [ ! -f "$SOURCE_DIR/packages/opencode/src/mcp/index.ts" ]; then
  echo "ERROR: Source not found at $SOURCE_DIR"
  exit 1
fi

# 2. Verify patch is present
if ! grep -q "stripUnknownFormats" "$SOURCE_DIR/packages/opencode/src/mcp/index.ts"; then
  echo "ERROR: Patch not found in source. Check mcp/index.ts"
  exit 1
fi

# 3. Build
echo "Building..."
cd "$SOURCE_DIR/packages/opencode"
bun run build --single

if [ ! -f "$BUILD_OUTPUT" ]; then
  echo "ERROR: Build output not found at $BUILD_OUTPUT"
  exit 1
fi

# 4. Backup current binary
if [ -f "$BINARY_DIR/opencode" ]; then
  cp "$BINARY_DIR/opencode" "$BINARY_DIR/opencode.bak"
  echo "Backed up current binary"
fi

# 5. Deploy
cp "$BUILD_OUTPUT" "$BINARY_DIR/opencode"
chmod +x "$BINARY_DIR/opencode"

# 6. Verify
if strings "$BINARY_DIR/opencode" | grep -q "stripUnknownFormats"; then
  echo "✅ Patch deployed successfully"
  echo "Binary: $BINARY_DIR/opencode"
  echo "Size: $(du -h "$BINARY_DIR/opencode" | cut -f1)"
else
  echo "ERROR: Patch verification failed!"
  echo "Restoring backup..."
  cp "$BINARY_DIR/opencode.bak" "$BINARY_DIR/opencode"
  exit 1
fi
