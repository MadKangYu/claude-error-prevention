#!/bin/bash
# lib/utils.sh - Common utilities

# Colors
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
C='\033[0;36m'
N='\033[0m'

# Logging
log()      { echo -e "${B}[INFO]${N} $*"; }
log_ok()   { echo -e "${G}[OK]${N} $*"; }
log_err()  { echo -e "${R}[ERROR]${N} $*"; }
log_warn() { echo -e "${Y}[WARN]${N} $*"; }
log_fix()  { echo -e "${G}[FIX]${N} $*"; }
log_debug(){ [[ "${DEBUG:-}" == "1" ]] && echo -e "${C}[DEBUG]${N} $*"; }

# Timestamps
timestamp() { date -Iseconds; }
timestamp_file() { date +%Y%m%d-%H%M%S; }

# Check dependencies
check_dep() {
  local cmd="$1"
  local install_hint="${2:-}"
  if ! command -v "$cmd" &>/dev/null; then
    log_err "$cmd not found"
    [[ -n "$install_hint" ]] && echo "  Install: $install_hint"
    return 1
  fi
  return 0
}

# Backup file
backup_file() {
  local file="$1"
  local backup_dir="${2:-$HOME/.claude/error-logs/backups}"

  mkdir -p "$backup_dir"

  if [[ -f "$file" ]]; then
    local backup="${backup_dir}/$(basename "$file").$(timestamp_file).bak"
    cp "$file" "$backup"
    echo "$backup"
  fi
}

# Validate JSON
validate_json() {
  local file="$1"
  jq empty "$file" 2>/dev/null
}

# Fix common JSON issues
fix_json() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    return 1
  fi

  # Backup first
  backup_file "$file" >/dev/null

  # Remove trailing commas
  local content
  content=$(cat "$file")
  content=$(echo "$content" | sed 's/,\s*}/}/g' | sed 's/,\s*]/]/g')

  echo "$content" > "$file"

  validate_json "$file"
}

# Confirm dangerous action
confirm_action() {
  local message="$1"
  local default="${2:-n}"

  echo -e "${Y}[CONFIRM]${N} $message"
  read -r -p "Continue? [y/N] " response

  [[ "$response" =~ ^[Yy]$ ]]
}
