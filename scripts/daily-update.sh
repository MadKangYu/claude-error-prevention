#!/bin/bash
#==============================================================================
# DAILY UPDATE SCRIPT
# Run via cron: 0 9 * * * ~/claude-error-prevention/scripts/daily-update.sh
#==============================================================================

REPO_DIR="${HOME}/claude-error-prevention"
LOG_FILE="${HOME}/.claude/error-logs/daily-update.log"

mkdir -p "$(dirname "$LOG_FILE")"

{
  echo "=== Daily Update: $(date) ==="

  # Pull latest
  cd "$REPO_DIR" && git pull origin main

  # Run heal
  ./src/error-engine.sh heal

  echo "=== Complete ==="
  echo ""
} >> "$LOG_FILE" 2>&1
