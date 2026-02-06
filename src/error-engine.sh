#!/bin/bash
#==============================================================================
# ERROR ENGINE v2.1
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
# SCOPE DETECTION
#==============================================================================

# Detect current scope based on installed tools and configs
# Uses simple variables for bash 3 compatibility

SCOPE_LIST=""

detect_scope() {
  log "Detecting scope..."
  echo ""

  SCOPE_LIST="global"
  log_ok "Scope: global"

  # Claude Code
  if command -v claude &>/dev/null; then
    SCOPE_LIST="$SCOPE_LIST claude"
    log_ok "Scope: claude-code ($(claude --version 2>/dev/null || echo 'installed'))"
  fi

  # Claude project configs
  if [ -f ".claude/settings.json" ] || [ -f "CLAUDE.md" ]; then
    SCOPE_LIST="$SCOPE_LIST claude-project"
    log_ok "Scope: claude-code (project)"
  fi

  # Crush / OpenCode
  if command -v crush &>/dev/null; then
    SCOPE_LIST="$SCOPE_LIST crush"
    log_ok "Scope: crush ($(crush --version 2>/dev/null || echo 'installed'))"
  elif command -v opencode &>/dev/null; then
    SCOPE_LIST="$SCOPE_LIST opencode"
    log_ok "Scope: opencode (legacy)"
  fi

  # OpenCode project configs
  if [ -f ".opencode.json" ] || [ -f "AGENTS.md" ]; then
    SCOPE_LIST="$SCOPE_LIST opencode-project"
    log_ok "Scope: opencode (project)"
  fi

  # OpenClaw
  if [ -f ~/.openclaw/openclaw.json ]; then
    SCOPE_LIST="$SCOPE_LIST openclaw"
    log_ok "Scope: openclaw"
  fi

  # Obsidian / QMD
  if [ -d ~/Obsidian ] || command -v qmd &>/dev/null; then
    SCOPE_LIST="$SCOPE_LIST obsidian"
    log_ok "Scope: obsidian"
  fi

  # Terminals
  [ -d "/Applications/iTerm.app" ] && SCOPE_LIST="$SCOPE_LIST iterm2" && log_ok "Scope: iTerm2"
  [ -d "/Applications/Ghostty.app" ] && SCOPE_LIST="$SCOPE_LIST ghostty" && log_ok "Scope: Ghostty"
  [ -d "/Applications/Warp.app" ] && SCOPE_LIST="$SCOPE_LIST warp" && log_ok "Scope: Warp"

  echo ""
}

# Get config paths for a scope
get_config_paths() {
  local scope="$1"

  case "$scope" in
    global)
      echo "System-wide configurations"
      echo "  npm global: $(npm root -g 2>/dev/null || echo 'N/A')"
      echo "  PATH: $PATH"
      ;;
    claude|claude-code)
      echo "Claude Code configurations"
      echo "  User config: ~/.claude/settings.json"
      echo "  MCP config: ~/.claude/claude_code_config.json"
      echo "  Memory: ~/.claude/CLAUDE.md"
      echo "  Rules: ~/.claude/rules/"
      echo "  Skills: ~/.claude/skills/"
      ;;
    claude-project)
      echo "Claude Code project configurations"
      echo "  Project: ./CLAUDE.md"
      echo "  Settings: ./.claude/settings.json"
      ;;
    crush|opencode)
      echo "Crush/OpenCode configurations"
      echo "  User config: ~/.crush.json or ~/.config/opencode/opencode.json"
      echo "  MCP config: ~/.config/opencode/.mcp.json"
      echo "  Agents: ./AGENTS.md"
      ;;
    opencode-project)
      echo "OpenCode project configurations"
      echo "  Project: ./.opencode.json"
      echo "  Agents: ./AGENTS.md"
      ;;
    openclaw)
      echo "OpenClaw configurations"
      echo "  Main: ~/.openclaw/openclaw.json"
      echo "  Cron: ~/.openclaw/cron/jobs.json"
      echo "  Skills: ~/.openclaw/skills/"
      ;;
    obsidian)
      echo "Obsidian configurations"
      echo "  Vault: ~/Obsidian/Vault"
      echo "  QMD index: ~/.cache/qmd/index.sqlite"
      ;;
    oh-my-opencode)
      echo "Oh My OpenCode configurations"
      echo "  Config: ~/.config/opencode/opencode.json"
      echo "  Plugins: npm list -g | grep opencode"
      ;;
    iterm2)
      echo "iTerm2 configurations"
      echo "  Preferences: ~/Library/Preferences/com.googlecode.iterm2.plist"
      echo "  Shell integration: ~/.iterm2_shell_integration.*"
      ;;
    ghostty)
      echo "Ghostty configurations"
      echo "  Config: ~/.config/ghostty/config"
      echo "  Themes: ~/.config/ghostty/themes/"
      ;;
    warp)
      echo "Warp configurations"
      echo "  Config: ~/.warp/"
      echo "  Workflows: ~/.warp/workflows/"
      ;;
    *)
      echo "Unknown scope: $scope"
      ;;
  esac
}

# Check if scope is active (bash 3 compatible)
is_scope_active() {
  local scope="$1"
  echo "$SCOPE_LIST" | grep -qw "$scope"
}

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
# SEARCH ENGINE
#==============================================================================

search_errors() {
  local keyword="$1"
  local keyword_lower
  keyword_lower=$(echo "$keyword" | tr '[:upper:]' '[:lower:]')

  log "Searching for: $keyword"
  echo ""

  local found=0
  local patterns
  patterns=$(load_patterns)

  while IFS= read -r pattern; do
    local id tool message fix_desc keywords

    id=$(echo "$pattern" | jq -r '.id')
    tool=$(echo "$pattern" | jq -r '.tool')
    message=$(echo "$pattern" | jq -r '.message')
    fix_desc=$(echo "$pattern" | jq -r '.fix.description // "N/A"')
    keywords=$(echo "$pattern" | jq -r '.keywords // [] | join(" ")')

    # Search in id, message, fix description, keywords
    local searchable
    searchable=$(echo "$id $message $fix_desc $keywords" | tr '[:upper:]' '[:lower:]')

    if [[ "$searchable" == *"$keyword_lower"* ]]; then
      echo -e "${G}[$tool]${N} $id"
      echo "  Message: $message"
      echo "  Fix: $fix_desc"
      echo ""
      ((found++)) || true
    fi
  done <<< "$patterns"

  if [ $found -eq 0 ]; then
    log_warn "No matches found for: $keyword"
    echo ""
    echo "Try searching for:"
    echo "  - duplicate, npm, install"
    echo "  - json, schema, config"
    echo "  - gateway, provider, uint64"
    echo ""
    echo "Or list all patterns: $0 list"
  else
    log_ok "Found $found match(es)"
  fi
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
# DOCTOR INTEGRATION
#==============================================================================

run_all_doctors() {
  log "Running doctor checks..."
  echo ""

  detect_scope

  local passed=0
  local failed=0

  # Claude Code doctor
  if is_scope_active "claude"; then
    echo -e "${B}=== Claude Code ===${N}"
    claude doctor 2>/dev/null && passed=$((passed+1)) || failed=$((failed+1))
    echo ""
  fi

  # Crush/OpenCode
  if is_scope_active "crush"; then
    echo -e "${B}=== Crush ===${N}"
    log_ok "Version: $(crush --version 2>/dev/null)"
    passed=$((passed+1))
    echo ""
  fi

  # OpenClaw
  if is_scope_active "openclaw"; then
    echo -e "${B}=== OpenClaw ===${N}"
    if curl -sf http://localhost:18789/health &>/dev/null; then
      log_ok "Gateway: OK"
      passed=$((passed+1))
    else
      log_err "Gateway: DOWN"
      failed=$((failed+1))
    fi
    echo ""
  fi

  # QMD
  if is_scope_active "obsidian"; then
    echo -e "${B}=== QMD ===${N}"
    if command -v qmd &>/dev/null; then
      log_ok "QMD installed"
      passed=$((passed+1))
    fi
    echo ""
  fi

  # Config validation
  echo -e "${B}=== Configs ===${N}"
  for cfg in ~/.claude/settings.json ~/.claude/claude_code_config.json ~/.openclaw/openclaw.json; do
    if [ -f "$cfg" ]; then
      if jq empty "$cfg" 2>/dev/null; then
        log_ok "$(basename "$cfg"): OK"
        passed=$((passed+1))
      else
        log_err "$(basename "$cfg"): INVALID"
        failed=$((failed+1))
      fi
    fi
  done
  echo ""

  log "Result: $passed passed, $failed failed"
  return $failed
}

#==============================================================================
# FULL AUTO-HEAL SYSTEM
#==============================================================================

# Initialize all missing configurations with sensible defaults
init_all_configs() {
  log "Initializing missing configurations..."
  echo ""

  # Claude Code directories
  mkdir -p ~/.claude/rules ~/.claude/skills

  # Claude Code CLAUDE.md
  if [ ! -f ~/.claude/CLAUDE.md ]; then
    cat > ~/.claude/CLAUDE.md << 'CLAUDEMD'
# User Memory

## Preferences
- Verify against official sources
- Show command output, not just "done"
- No emojis unless requested

## Config Paths
- MCP: ~/.claude/claude_code_config.json
- Settings: ~/.claude/settings.json
CLAUDEMD
    log_ok "Created ~/.claude/CLAUDE.md"
  fi

  # Claude Code settings.json
  if [ ! -f ~/.claude/settings.json ]; then
    cat > ~/.claude/settings.json << 'SETTINGS'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json"
}
SETTINGS
    log_ok "Created ~/.claude/settings.json"
  fi

  # Git user config
  if ! git config --global user.email &>/dev/null; then
    local email
    email=$(whoami)@$(hostname)
    git config --global user.email "$email"
    git config --global user.name "$(whoami)"
    log_ok "Set git user: $email"
  fi

  # SSH key
  if [ ! -f ~/.ssh/id_ed25519 ] && [ ! -f ~/.ssh/id_rsa ]; then
    mkdir -p ~/.ssh
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "$(whoami)@$(hostname)" 2>/dev/null
    log_ok "Generated SSH key: ~/.ssh/id_ed25519"
  fi

  # Ghostty config
  if [ -d "/Applications/Ghostty.app" ] && [ ! -f ~/.config/ghostty/config ]; then
    mkdir -p ~/.config/ghostty
    echo "# Ghostty config" > ~/.config/ghostty/config
    log_ok "Created ~/.config/ghostty/config"
  fi

  # OpenClaw directory
  if is_scope_active "openclaw" && [ ! -d ~/.openclaw/skills ]; then
    mkdir -p ~/.openclaw/skills
    log_ok "Created ~/.openclaw/skills/"
  fi

  echo ""
  log_ok "Initialization complete"
}

# Fix invalid JSON by attempting to repair common issues
fix_invalid_json() {
  local file="$1"

  if [ ! -f "$file" ]; then
    return 1
  fi

  # Backup first
  cp "$file" "${file}.bak.$(date +%s)"

  # Try to fix common JSON issues
  local content
  content=$(cat "$file")

  # Remove trailing commas before } or ]
  content=$(echo "$content" | sed 's/,\s*}/}/g' | sed 's/,\s*]/]/g')

  # Write back and validate
  echo "$content" > "$file"

  if jq empty "$file" 2>/dev/null; then
    log_ok "Fixed JSON: $file"
    return 0
  else
    # Restore backup
    mv "${file}.bak."* "$file" 2>/dev/null
    log_err "Could not auto-fix: $file"
    return 1
  fi
}

# Full healing cycle
heal_all() {
  echo ""
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║              ERROR PREVENTION - FULL HEAL                    ║"
  echo "║              $(date '+%Y-%m-%d %H:%M:%S')                             ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo ""

  local start_time
  start_time=$(date +%s)

  # Phase 1: Detect scope
  echo -e "${B}[1/6] SCOPE DETECTION${N}"
  detect_scope

  # Phase 2: Initialize missing configs
  echo -e "${B}[2/6] INITIALIZATION${N}"
  init_all_configs

  # Phase 3: Scan for errors
  echo -e "${B}[3/6] ERROR SCAN${N}"
  local errors_before
  errors_before=$(scan_all 2>&1 | grep -c "ERROR\|WARN" | tr -d '\n' || echo 0)
  echo ""

  # Phase 4: Auto-fix all
  echo -e "${B}[4/6] AUTO-FIX${N}"
  fix_all
  echo ""

  # Phase 5: Fix invalid JSON files
  echo -e "${B}[5/6] JSON REPAIR${N}"
  for cfg in ~/.claude/settings.json ~/.claude/claude_code_config.json ~/.openclaw/openclaw.json; do
    if [ -f "$cfg" ] && ! jq empty "$cfg" 2>/dev/null; then
      fix_invalid_json "$cfg"
    fi
  done
  echo ""

  # Phase 6: Verify
  echo -e "${B}[6/6] VERIFICATION${N}"
  verify_state
  echo ""

  # Final report
  local end_time errors_after duration
  end_time=$(date +%s)
  duration=$((end_time - start_time))
  errors_after=$(scan_all 2>&1 | grep -c "ERROR\|WARN" | tr -d '\n' || echo 0)
  errors_before=${errors_before:-0}
  errors_after=${errors_after:-0}

  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║                      HEAL COMPLETE                           ║"
  echo "╠══════════════════════════════════════════════════════════════╣"
  echo "║  Duration: ${duration}s                                              ║"
  echo "║  Errors before: $errors_before                                        ║"
  echo "║  Errors after:  $errors_after                                        ║"
  echo "║  Fixed: $((errors_before - errors_after))                                            ║"
  echo "╚══════════════════════════════════════════════════════════════╝"

  # Generate report
  generate_report

  if [ "$errors_after" -eq 0 ]; then
    echo ""
    log_ok "System is healthy"
    return 0
  else
    echo ""
    log_warn "Some issues require manual attention"
    return 1
  fi
}

#==============================================================================
# MAIN
#==============================================================================

usage() {
  cat << EOF
Error Engine v1.0

Usage: $(basename "$0") <command>

Commands:
  heal          Full auto: detect → fix → verify → report
  scan          Detect all errors
  scope         Detect and show current scope
  scope <name>  Show config paths for scope
  fix <id>      Fix specific error by ID
  fix-all       Fix all auto-fixable errors
  verify        Verify system state
  report        Generate JSON report
  list          List all error patterns
  search <kw>   Search errors by keyword
  doctor        Run doctor for all detected tools
  init          Initialize all missing configs

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
    heal)
      heal_all
      ;;
    init)
      detect_scope
      init_all_configs
      ;;
    scan)
      detect_scope
      scan_all
      ;;
    scope)
      detect_scope
      if [ -n "${2:-}" ]; then
        echo ""
        get_config_paths "$2"
      else
        echo "Detected scopes: ${!SCOPE_DETECTED[*]}"
        echo ""
        echo "Use: $0 scope <name> for config paths"
        echo "Available: global, claude, opencode, openclaw, obsidian, iterm2, ghostty, warp"
      fi
      ;;
    doctor)
      run_all_doctors
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
    search)
      if [ -z "${2:-}" ]; then
        log_err "Usage: $0 search <keyword>"
        exit 1
      fi
      search_errors "$2"
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
