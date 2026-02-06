#!/bin/bash
set -euo pipefail

local_file=${1:-}
github_url=${2:-}

if [ -z "$local_file" ] || [ -z "$github_url" ]; then
  echo "Usage: $0 <local_file> <github_raw_url>"
  echo "Example: $0 ./docs/schema.md https://raw.githubusercontent.com/owner/repo/main/docs/schema.md"
  exit 1
fi

if [ ! -f "$local_file" ]; then
  echo "ERROR: Local file not found: $local_file"
  exit 1
fi

echo "Local:  $local_file"
echo "Remote: $github_url"
echo ""

# Download to temp file
tmp_file=$(mktemp)
trap "rm -f $tmp_file" EXIT

if ! curl -sf "$github_url" > "$tmp_file"; then
  echo "ERROR: Failed to fetch remote file"
  exit 1
fi

# Compare
if diff -q "$local_file" "$tmp_file" &>/dev/null; then
  echo "✅ MATCH - Files are identical"
else
  echo "❌ DIFFERENT - Files do not match"
  echo ""
  echo "--- Diff (first 50 lines) ---"
  diff "$local_file" "$tmp_file" | head -50
fi
