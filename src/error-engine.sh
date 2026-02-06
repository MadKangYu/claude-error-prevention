#!/bin/bash
#==============================================================================
# ERROR ENGINE v1.0
# Pattern-based error detection, resolution, and verification
#
# Architecture:
#   1. DETECT  - Pattern matching against known errors
#   2. RESOLVE - Apply fixes with pre/post verification
#   3. VERIFY  - Confirm fix worked
#   4. ROLLBACK - Revert if fix failed
#   5. REPORT  - Log everything
#
# Usage:
#   ./error-engine.sh scan              # Detect errors
#   ./error-engine.sh fix <error-id>    # Fix specific error
#   ./error-engine.sh fix-all           # Fix all auto-fixable
#   ./error-engine.sh verify            # Verify current state
#   ./error-engine.sh report            # Generate report
#==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATTERNS_FILE="${SCRIPT_DIR}/../patterns/error-patterns.json"
LOG_DIR="${HOME}/.claude/error-logs"
BACKUP_DIR="${LOG_DIR}/backups"
STATE_FILE="${LOG_DIR}/state.json"

# Colors
R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m' B='\033[0;34m' N='\033[0m'

#==============================================================================
# UTILITIES
#==============================================================================

log()      { echo -e "${B}[INFO]${N} $*"; }
log_ok()   { echo -e "${G}[OK]${N} $*"; }
log_err()  { echo -e "${R}[ERROR]${N} $*"; }
log_warn() { echo -e "${Y}[WARN]${N} $*"; }
log_fix()  { echo -e "${G}[FIX]${N} $*"; }

ensure_deps() {
  if ! command -v jq &>/dev/null; then
    log_err "jq required. Install: brew install jq"
    exit 1
  fi
  mkdir -p "$LOG_DIR" "$BACKUP_DIR"
}

timestamp() { date -Iseconds; }

#==============================================================================
# PATTERN LOADING
#==============================================================================

load_patterns() {
  if [ ! -f "$PATTERNS_FILE" ]; then
    log_err "Patterns file not found: $PATTERNS_FILE"
    exit 1
  fi
  jq -c '.patterns[]' "$PATTERNS_FILE"
}

get_pattern() {
  local id="$1"
  jq -c ".patterns[] | select(.id == \"$id\")" "$PATTERNS_FILE"
}

#==============================================================================
# DETECTION ENGINE
#==============================================================================

check_tool_installed() {
  local tool="$1"
  case "$tool" in
    claude-code) command -v claude &>/dev/null ;;
    opencode)    command -v opencode &>/dev/null ;;
    openclaw)    [ -f ~/.openclaw/openclaw.json ] ;;
    system)      return 0 ;;
    *)           return 1 ;;
  esac
}

evaluate_condition() {
  local actual="$1"
  local condition="$2"
  local expected="$3"

  case "$condition" in
    eq)  [ "$actual" == "$expected" ] ;;
    neq) [ "$actual" != "$expected" ] ;;
    gt)  [ "$actual" -gt "$expected" ] 2>/dev/null ;;
    lt)  [ "$actual" -lt "$expected" ] 2>/dev/null ;;
    contains) [[ "$actual" == *"$expected"* ]] ;;
    *)   return 1 ;;
  esac
}

detect_error() {
  local pattern="$1"

  local id tool category detect_cmd condition expected

  id=$(echo "$pattern" | jq -r '.id')
  tool=$(echo "$pattern" | jq -r '.tool')
  category=$(echo "$pattern" | jq -r '.category')

  # Skip if tool not installed
  if ! check_tool_installed "$tool"; then
    return 1
  fi

  # Get detection parameters
  detect_cmd=$(echo "$pattern" | jq -r '.detect.command // empty')
  condition=$(echo "$pattern" | jq -r '.detect.condition // empty')
  expected=$(echo "$pattern" | jq -r '.detect.value // empty')

  # Skip log-pattern types for now
  if [ -z "$detect_cmd" ]; then
    return 1
  fi

  # Execute detection
  local actual
  actual=$(eval "$detect_cmd" 2>/dev/null || echo "error")

  # Skip if command failed
  if [ "$actual" == "error" ] || [ "$actual" == "skip" ]; then
    return 1
  fi

  # Evaluate condition
  if evaluate_condition "$actual" "$condition" "$expected"; then
    return 0  # Error detected
  fi

  return 1  # No error
}

scan_all() {
  log "Scanning for errors..."
  echo ""

  local errors_found=0
  local patterns
  patterns=$(load_patterns)

  while IFS= read -r pattern; do
    local id tool message severity

    id=$(echo "$pattern" | jq -r '.id')
    tool=$(echo "$pattern" | jq -r '.tool')
    message=$(echo "$pattern" | jq -r '.message')
    severity=$(echo "$pattern" | jq -r '.severity')

    if detect_error "$pattern"; then
      case "$severity" in
        error)   log_err "[$tool] $message (id: $id)" ;;
        warning) log_warn "[$tool] $message (id: $id)" ;;
        info)    log "[$tool] $message (id: $id)" ;;
      esac
      ((errors_found++)) || true
    fi
  done <<< "$patterns"

  echo ""
  if [ $errors_found -eq 0 ]; then
    log_ok "No errors detected"
  else
    log_err "Found $errors_found error(s)"
  fi

  return $errors_found
}

#==============================================================================
# RESOLUTION ENGINE
#==============================================================================

backup_file() {
  local file="$1"
  if [ -f "$file" ]; then
    local backup="${BACKUP_DIR}/$(basename "$file").$(date +%Y%m%d%H%M%S).bak"
    cp "$file" "$backup"
    echo "$backup"
  fi
}

apply_fix() {
  local id="$1"

  local pattern
  pattern=$(get_pattern "$id")

  if [ -z "$pattern" ] || [ "$pattern" == "null" ]; then
    log_err "Pattern not found: $id"
    return 1
  fi

  local fix_cmd fix_desc manual

  fix_cmd=$(echo "$pattern" | jq -r '.fix.command // empty')
  fix_desc=$(echo "$pattern" | jq -r '.fix.description // empty')
  manual=$(echo "$pattern" | jq -r '.fix.manual // false')

  if [ "$manual" == "true" ]; then
    log_warn "Manual fix required: $fix_desc"
    return 1
  fi

  if [ -z "$fix_cmd" ]; then
    log_warn "No fix available for: $id"
    return 1
  fi

  # Pre-verification: confirm error exists
  if ! detect_error "$pattern"; then
    log_ok "Error not present (already fixed?): $id"
    return 0
  fi

  log "Applying fix: $fix_desc"
  log "Command: $fix_cmd"

  # Execute fix
  if eval "$fix_cmd" 2>/dev/null; then
    log_fix "Fix applied"

    # Post-verification: confirm error resolved
    sleep 1
    if detect_error "$pattern"; then
      log_err "Fix did not resolve the error"
      return 1
    else
      log_ok "Verified: error resolved"
      return 0
    fi
  else
    log_err "Fix command failed"
    return 1
  fi
}

fix_all() {
  log "Applying all auto-fixable errors..."
  echo ""

  local fixed=0
  local failed=0
  local patterns
  patterns=$(load_patterns)

  while IFS= read -r pattern; do
    local id manual

    id=$(echo "$pattern" | jq -r '.id')
    manual=$(echo "$pattern" | jq -r '.fix.manual // false')

    # Skip manual fixes
    if [ "$manual" == "true" ]; then
      continue
    fi

    # Skip if no error
    if ! detect_error "$pattern"; then
      continue
    fi

    if apply_fix "$id"; then
      ((fixed++)) || true
    else
      ((failed++)) || true
    fi
    echo ""
  done <<< "$patterns"

  echo ""
  log "Results: $fixed fixed, $failed failed"
}

#==============================================================================
# VERIFICATION
#==============================================================================

verify_state() {
  log "Verifying system state..."
  echo ""

  local total=0
  local ok=0
  local errors=0

  # Claude Code
  if command -v claude &>/dev/null; then
    ((total++)) || true
    local version
    version=$(claude --version 2>/dev/null || echo "unknown")
    log_ok "Claude Code: $version"
    ((ok++)) || true
  fi

  # Check for duplicates
  local paths
  paths=$(which -a claude 2>/dev/null | wc -l | tr -d ' ')
  if [ "$paths" -le 1 ]; then
    log_ok "No duplicate installations"
    ((ok++)) || true
  else
    log_err "Duplicate installations: $paths"
    ((errors++)) || true
  fi
  ((total++)) || true

  # Config files
  if [ -f ~/.claude/settings.json ]; then
    if jq empty ~/.claude/settings.json 2>/dev/null; then
      log_ok "settings.json: valid JSON"
      ((ok++)) || true
    else
      log_err "settings.json: invalid JSON"
      ((errors++)) || true
    fi
  fi
  ((total++)) || true

  if [ -f ~/.claude/claude_code_config.json ]; then
    if jq empty ~/.claude/claude_code_config.json 2>/dev/null; then
      log_ok "claude_code_config.json: valid JSON"
      ((ok++)) || true
    else
      log_err "claude_code_config.json: invalid JSON"
      ((errors++)) || true
    fi
  fi
  ((total++)) || true

  echo ""
  log "Verification: $ok/$total passed, $errors errors"

  return $errors
}

#==============================================================================
# REPORTING
#==============================================================================

generate_report() {
  local report_file="${LOG_DIR}/report-$(date +%Y%m%d-%H%M%S).json"

  log "Generating report..."

  local errors=()
  local patterns
  patterns=$(load_patterns)

  while IFS= read -r pattern; do
    if detect_error "$pattern"; then
      local id message severity
      id=$(echo "$pattern" | jq -r '.id')
      message=$(echo "$pattern" | jq -r '.message')
      severity=$(echo "$pattern" | jq -r '.severity')
      errors+=("{\"id\":\"$id\",\"message\":\"$message\",\"severity\":\"$severity\"}")
    fi
  done <<< "$patterns"

  local errors_json="[]"
  for e in "${errors[@]:-}"; do
    errors_json=$(echo "$errors_json" | jq ". + [$e]")
  done

  cat > "$report_file" << EOF
{
  "generated": "$(timestamp)",
  "hostname": "$(hostname)",
  "user": "$(whoami)",
  "errors_count": ${#errors[@]},
  "errors": $errors_json,
  "claude_version": "$(claude --version 2>/dev/null || echo 'not installed')",
  "opencode_version": "$(opencode --version 2>/dev/null || echo 'not installed')"
}
EOF

  log_ok "Report saved: $report_file"
  cat "$report_file" | jq .
}

#==============================================================================
# MAIN
#==============================================================================

usage() {
  cat << EOF
Error Engine v1.0

Usage: $(basename "$0") <command>

Commands:
  scan        Detect all errors
  fix <id>    Fix specific error by ID
  fix-all     Fix all auto-fixable errors
  verify      Verify system state
  report      Generate JSON report
  list        List all error patterns

Options:
  -h, --help  Show this help

Examples:
  $(basename "$0") scan
  $(basename "$0") fix claude-duplicate-install
  $(basename "$0") fix-all
EOF
}

main() {
  ensure_deps

  local cmd="${1:-}"

  case "$cmd" in
    scan)
      scan_all
      ;;
    fix)
      if [ -z "${2:-}" ]; then
        log_err "Usage: $0 fix <error-id>"
        exit 1
      fi
      apply_fix "$2"
      ;;
    fix-all)
      fix_all
      ;;
    verify)
      verify_state
      ;;
    report)
      generate_report
      ;;
    list)
      jq -r '.patterns[] | "\(.id)\t\(.severity)\t\(.message)"' "$PATTERNS_FILE" | column -t -s $'\t'
      ;;
    -h|--help|"")
      usage
      ;;
    *)
      log_err "Unknown command: $cmd"
      usage
      exit 1
      ;;
  esac
}

main "$@"
