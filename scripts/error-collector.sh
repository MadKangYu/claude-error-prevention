#!/bin/bash
#
# Error Collector & Auto-Resolver
# Collects errors from AI coding tools and applies automatic fixes
#
# Usage: ./error-collector.sh [--fix] [--report] [--watch]
#
set -euo pipefail

# Configuration
LOG_DIR="${HOME}/.claude/error-logs"
PATTERNS_FILE="$(dirname "$0")/../patterns/error-patterns.json"
REPORT_FILE="${LOG_DIR}/report-$(date +%Y%m%d-%H%M%S).json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Ensure directories exist
mkdir -p "$LOG_DIR"

# Parse arguments
FIX_MODE=false
REPORT_MODE=false
WATCH_MODE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --fix) FIX_MODE=true; shift ;;
    --report) REPORT_MODE=true; shift ;;
    --watch) WATCH_MODE=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# Error collection array
declare -a ERRORS=()
declare -a FIXES_APPLIED=()
declare -a FIXES_PENDING=()

log_error() {
  local tool="$1"
  local category="$2"
  local message="$3"
  local fix="${4:-}"

  ERRORS+=("{\"tool\":\"$tool\",\"category\":\"$category\",\"message\":\"$message\",\"fix\":\"$fix\",\"timestamp\":\"$(date -Iseconds)\"}")
  echo -e "${RED}[ERROR]${NC} [$tool] $category: $message"

  if [ -n "$fix" ]; then
    FIXES_PENDING+=("$fix")
  fi
}

log_warning() {
  local tool="$1"
  local message="$2"
  echo -e "${YELLOW}[WARN]${NC} [$tool] $message"
}

log_success() {
  local message="$1"
  echo -e "${GREEN}[OK]${NC} $message"
}

log_fix() {
  local message="$1"
  FIXES_APPLIED+=("$message")
  echo -e "${BLUE}[FIX]${NC} $message"
}

#=============================================================================
# ERROR DETECTION FUNCTIONS
#=============================================================================

check_claude_code() {
  echo -e "\n${BLUE}=== Claude Code ===${NC}"

  # 1. Installation check
  if ! command -v claude &>/dev/null; then
    log_error "claude-code" "installation" "Not installed" \
      "curl -fsSL https://claude.ai/install.sh | bash"
    return
  fi

  # 2. Version check
  local version
  version=$(claude --version 2>/dev/null || echo "unknown")
  log_success "Version: $version"

  # 3. Duplicate installation check
  local paths
  paths=$(which -a claude 2>/dev/null | wc -l | tr -d ' ')
  if [ "$paths" -gt 1 ]; then
    log_error "claude-code" "duplicate" "Multiple installations found: $paths" \
      "npm -g uninstall @anthropic-ai/claude-code"
  fi

  # 4. npm deprecated installation
  if npm list -g @anthropic-ai/claude-code 2>/dev/null | grep -q claude-code; then
    log_error "claude-code" "deprecated" "npm installation exists (deprecated)" \
      "npm -g uninstall @anthropic-ai/claude-code"
  fi

  # 5. Config file checks
  if [ -f ~/.claude/settings.json ]; then
    # Schema validation
    local schema
    schema=$(jq -r '."$schema" // empty' ~/.claude/settings.json 2>/dev/null)
    local expected="https://json.schemastore.org/claude-code-settings.json"

    if [ -z "$schema" ]; then
      log_error "claude-code" "config" "Missing \$schema in settings.json" \
        "jq '. + {\"\$schema\": \"$expected\"}' ~/.claude/settings.json > /tmp/s.json && mv /tmp/s.json ~/.claude/settings.json"
    elif [ "$schema" != "$expected" ]; then
      log_error "claude-code" "config" "Wrong \$schema value" \
        "jq '.\"\$schema\" = \"$expected\"' ~/.claude/settings.json > /tmp/s.json && mv /tmp/s.json ~/.claude/settings.json"
    fi

    # JSON validity
    if ! jq empty ~/.claude/settings.json 2>/dev/null; then
      log_error "claude-code" "config" "Invalid JSON in settings.json" ""
    fi
  fi

  # 6. MCP config check
  if [ -f ~/.claude/claude_code_config.json ]; then
    if ! jq empty ~/.claude/claude_code_config.json 2>/dev/null; then
      log_error "claude-code" "config" "Invalid JSON in claude_code_config.json" ""
    else
      log_success "MCP config valid"
    fi
  fi

  # 7. Deprecated config location
  if [ -f ~/.mcp.json ]; then
    log_error "claude-code" "deprecated" "~/.mcp.json exists (use ~/.claude/claude_code_config.json)" \
      "mv ~/.mcp.json ~/.mcp.json.bak"
  fi

  # 8. Memory files
  if [ ! -f ~/.claude/CLAUDE.md ]; then
    log_warning "claude-code" "No user memory file (~/.claude/CLAUDE.md)"
  fi

  if [ ! -d ~/.claude/rules ]; then
    log_warning "claude-code" "No rules directory (~/.claude/rules/)"
  fi
}

check_opencode() {
  echo -e "\n${BLUE}=== OpenCode ===${NC}"

  if ! command -v opencode &>/dev/null; then
    log_warning "opencode" "Not installed"
    return
  fi

  local version
  version=$(opencode --version 2>/dev/null || echo "unknown")
  log_success "Version: $version"

  # Config check
  if [ -f ~/.config/opencode/opencode.json ]; then
    if ! jq empty ~/.config/opencode/opencode.json 2>/dev/null; then
      log_error "opencode" "config" "Invalid JSON in opencode.json" ""
    else
      log_success "Config valid"
    fi

    # Check for providers
    local providers
    providers=$(jq -r '.provider // .providers | keys | length' ~/.config/opencode/opencode.json 2>/dev/null || echo "0")
    if [ "$providers" == "0" ]; then
      log_warning "opencode" "No providers configured"
    fi
  else
    log_warning "opencode" "Config not found"
  fi

  # AGENTS.md in current directory
  if [ -f ./AGENTS.md ]; then
    log_success "AGENTS.md found in current directory"
  fi
}

check_openclaw() {
  echo -e "\n${BLUE}=== OpenClaw ===${NC}"

  if [ ! -f ~/.openclaw/openclaw.json ]; then
    log_warning "openclaw" "Not configured"
    return
  fi

  # Version check
  local version
  version=$(jq -r '.meta.lastTouchedVersion // "unknown"' ~/.openclaw/openclaw.json 2>/dev/null)
  log_success "Version: $version"

  # Config validity
  if ! jq empty ~/.openclaw/openclaw.json 2>/dev/null; then
    log_error "openclaw" "config" "Invalid JSON in openclaw.json" ""
  fi

  # Gateway check
  if curl -sf http://localhost:18789/health &>/dev/null; then
    log_success "Gateway responding"
  else
    log_warning "openclaw" "Gateway not responding (localhost:18789)"
  fi

  # Security checks
  if [ -f ~/.openclaw/.env ]; then
    log_error "openclaw" "security" ".env file in openclaw directory (potential leak)" \
      "mv ~/.openclaw/.env ~/.openclaw/.env.bak && echo 'Rotate tokens!'"
  fi
}

check_services() {
  echo -e "\n${BLUE}=== Services ===${NC}"

  # Browserless
  if curl -sf http://localhost:3000 &>/dev/null; then
    log_success "Browserless: localhost:3000"
  else
    log_warning "services" "Browserless not running"
  fi

  # CouchDB
  if curl -sf http://localhost:5984 &>/dev/null; then
    log_success "CouchDB: localhost:5984"
  else
    log_warning "services" "CouchDB not running"
  fi

  # QMD
  if command -v qmd &>/dev/null; then
    log_success "QMD installed"
  fi
}

check_environment() {
  echo -e "\n${BLUE}=== Environment ===${NC}"

  # API Keys (check existence only)
  [ -n "${ANTHROPIC_API_KEY:-}" ] && log_success "ANTHROPIC_API_KEY set" || log_warning "env" "ANTHROPIC_API_KEY not set"
  [ -n "${OPENAI_API_KEY:-}" ] && log_success "OPENAI_API_KEY set" || log_warning "env" "OPENAI_API_KEY not set"
  [ -n "${GEMINI_API_KEY:-}" ] && log_success "GEMINI_API_KEY set" || log_warning "env" "GEMINI_API_KEY not set"

  # Shell
  log_success "Shell: $SHELL"

  # Node version
  if command -v node &>/dev/null; then
    log_success "Node: $(node --version)"
  fi

  # jq (required for this script)
  if ! command -v jq &>/dev/null; then
    log_error "env" "dependency" "jq not installed" "brew install jq"
  fi
}

#=============================================================================
# FIX APPLICATION
#=============================================================================

apply_fixes() {
  if [ ${#FIXES_PENDING[@]} -eq 0 ]; then
    echo -e "\n${GREEN}No fixes needed.${NC}"
    return
  fi

  echo -e "\n${BLUE}=== Applying Fixes ===${NC}"

  for fix in "${FIXES_PENDING[@]}"; do
    if [ -n "$fix" ]; then
      echo -e "${YELLOW}Executing:${NC} $fix"

      if $FIX_MODE; then
        if eval "$fix" 2>/dev/null; then
          log_fix "$fix"
        else
          echo -e "${RED}Failed to apply fix${NC}"
        fi
      else
        echo -e "${YELLOW}(Use --fix to apply)${NC}"
      fi
    fi
  done
}

#=============================================================================
# REPORT GENERATION
#=============================================================================

generate_report() {
  if ! $REPORT_MODE; then
    return
  fi

  echo -e "\n${BLUE}=== Generating Report ===${NC}"

  local errors_json="[]"
  for e in "${ERRORS[@]}"; do
    errors_json=$(echo "$errors_json" | jq ". + [$e]")
  done

  local fixes_json="[]"
  for f in "${FIXES_APPLIED[@]}"; do
    fixes_json=$(echo "$fixes_json" | jq ". + [\"$f\"]")
  done

  cat > "$REPORT_FILE" << EOF
{
  "generated": "$(date -Iseconds)",
  "hostname": "$(hostname)",
  "errors_count": ${#ERRORS[@]},
  "fixes_applied": ${#FIXES_APPLIED[@]},
  "errors": $errors_json,
  "fixes": $fixes_json
}
EOF

  echo "Report saved to: $REPORT_FILE"
}

#=============================================================================
# WATCH MODE
#=============================================================================

watch_errors() {
  if ! $WATCH_MODE; then
    return
  fi

  echo -e "\n${BLUE}=== Watch Mode ===${NC}"
  echo "Monitoring for errors... (Ctrl+C to stop)"

  # Watch Claude Code logs
  if [ -d ~/.claude/debug ]; then
    tail -f ~/.claude/debug/*.log 2>/dev/null | while read -r line; do
      if echo "$line" | grep -qi "error\|fail\|exception"; then
        echo -e "${RED}[DETECTED]${NC} $line"
      fi
    done &
  fi

  # Watch OpenCode logs
  if [ -d ~/.config/opencode/logs ]; then
    tail -f ~/.config/opencode/logs/*.log 2>/dev/null | while read -r line; do
      if echo "$line" | grep -qi "error\|fail\|exception"; then
        echo -e "${RED}[DETECTED]${NC} $line"
      fi
    done &
  fi

  wait
}

#=============================================================================
# MAIN
#=============================================================================

main() {
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║           Error Collector & Auto-Resolver                    ║"
  echo "║           $(date '+%Y-%m-%d %H:%M:%S')                              ║"
  echo "╚══════════════════════════════════════════════════════════════╝"

  # Run all checks
  check_claude_code
  check_opencode
  check_openclaw
  check_services
  check_environment

  # Summary
  echo -e "\n${BLUE}=== Summary ===${NC}"
  echo "Errors found: ${#ERRORS[@]}"
  echo "Fixes pending: ${#FIXES_PENDING[@]}"

  # Apply fixes if requested
  apply_fixes

  # Generate report if requested
  generate_report

  # Enter watch mode if requested
  watch_errors

  # Exit code based on errors
  if [ ${#ERRORS[@]} -gt 0 ]; then
    exit 1
  fi
}

main "$@"
