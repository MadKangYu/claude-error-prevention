#!/bin/bash
set -euo pipefail

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         Local Environment Verification Script                 ║"
echo "║         Last Updated: 2026-02-07                             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pass() { echo -e "${GREEN}✓${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }

echo "=== 1. Claude Code ==="

if command -v claude &>/dev/null; then
  version=$(claude --version 2>/dev/null || echo "unknown")
  pass "Installed: $version"

  path=$(which claude)
  if [[ "$path" == *".local/bin"* ]]; then
    pass "Path: $path (native)"
  else
    warn "Path: $path (not native)"
  fi

  count=$(which -a claude 2>/dev/null | wc -l | tr -d ' ')
  if [ "$count" -gt 1 ]; then
    fail "Multiple installations: $count (run: npm -g uninstall @anthropic-ai/claude-code)"
  else
    pass "Single installation"
  fi
else
  fail "NOT INSTALLED"
fi

echo ""
echo "=== 2. npm Duplicates ==="

if npm list -g @anthropic-ai/claude-code 2>/dev/null | grep -q claude-code; then
  fail "Deprecated npm installation found"
  echo "    Fix: npm -g uninstall @anthropic-ai/claude-code"
else
  pass "No deprecated npm installation"
fi

echo ""
echo "=== 3. Config Files ==="

# Claude Code MCP config
if [ -f ~/.claude/claude_code_config.json ]; then
  if jq empty ~/.claude/claude_code_config.json 2>/dev/null; then
    pass "MCP config: ~/.claude/claude_code_config.json (valid JSON)"
  else
    fail "MCP config: Invalid JSON"
  fi
else
  warn "MCP config not found"
fi

# Claude Code settings
if [ -f ~/.claude/settings.json ]; then
  schema=$(jq -r '."$schema"' ~/.claude/settings.json 2>/dev/null)
  expected="https://json.schemastore.org/claude-code-settings.json"
  if [ "$schema" == "$expected" ]; then
    pass "Settings schema: correct"
  else
    fail "Settings schema: wrong (expected: $expected)"
  fi
else
  warn "Settings not found"
fi

# CLAUDE.md
if [ -f ~/.claude/CLAUDE.md ]; then
  pass "User memory: ~/.claude/CLAUDE.md"
else
  warn "User memory not set"
fi

# Rules directory
if [ -d ~/.claude/rules ]; then
  count=$(ls ~/.claude/rules/*.md 2>/dev/null | wc -l | tr -d ' ')
  pass "Rules: $count files"
else
  warn "Rules directory not found"
fi

# Wrong config locations
if [ -f ~/.mcp.json ]; then
  fail "Deprecated: ~/.mcp.json exists (should use ~/.claude/claude_code_config.json)"
fi

echo ""
echo "=== 4. OpenCode ==="

if command -v opencode &>/dev/null; then
  version=$(opencode --version 2>/dev/null || echo "unknown")
  pass "Installed: $version"
else
  warn "OpenCode not installed"
fi

if [ -f ~/.config/opencode/opencode.json ]; then
  pass "Config: ~/.config/opencode/opencode.json"
else
  warn "OpenCode config not found"
fi

echo ""
echo "=== 5. OpenClaw ==="

if [ -f ~/.openclaw/openclaw.json ]; then
  version=$(jq -r '.meta.lastTouchedVersion' ~/.openclaw/openclaw.json 2>/dev/null)
  pass "Config found: version $version"
else
  warn "OpenClaw config not found"
fi

# Gateway check
if curl -sf http://localhost:18789/health &>/dev/null; then
  pass "Gateway: localhost:18789 responding"
else
  warn "Gateway: not responding"
fi

echo ""
echo "=== 6. Services ==="

# Browserless
if curl -sf http://localhost:3000 &>/dev/null; then
  pass "Browserless: localhost:3000"
else
  warn "Browserless: not running"
fi

# CouchDB
if curl -sf http://localhost:5984 &>/dev/null; then
  pass "CouchDB: localhost:5984"
else
  warn "CouchDB: not running"
fi

echo ""
echo "=== 7. Environment ==="

# Check common API keys (existence only, not values)
[ -n "${ANTHROPIC_API_KEY:-}" ] && pass "ANTHROPIC_API_KEY set" || warn "ANTHROPIC_API_KEY not set"
[ -n "${OPENAI_API_KEY:-}" ] && pass "OPENAI_API_KEY set" || warn "OPENAI_API_KEY not set"
[ -n "${GEMINI_API_KEY:-}" ] && pass "GEMINI_API_KEY set" || warn "GEMINI_API_KEY not set"

echo ""
echo "=== Done ==="
