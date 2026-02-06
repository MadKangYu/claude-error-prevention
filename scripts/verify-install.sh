#!/bin/bash
set -euo pipefail

cmd=${1:-}
if [ -z "$cmd" ]; then
  echo "Usage: $0 <command>"
  echo "Example: $0 claude"
  exit 1
fi

echo "=== Checking: $cmd ==="

# Path
if command -v "$cmd" &>/dev/null; then
  echo "Path: $(which "$cmd")"
else
  echo "ERROR: Not found in PATH"
  exit 1
fi

# Version
echo -n "Version: "
"$cmd" --version 2>/dev/null || "$cmd" -v 2>/dev/null || echo "unknown"

# Duplicates
count=$(which -a "$cmd" 2>/dev/null | wc -l | tr -d ' ')
echo "Installations: $count"
[ "$count" -gt 1 ] && echo "WARNING: Multiple installations found"

# Executable test
if "$cmd" --help &>/dev/null; then
  echo "Executable: OK"
else
  echo "Executable: FAILED (--help returned error)"
fi
