#!/bin/bash
set -euo pipefail

echo "=== Claude Code ==="
if command -v claude &>/dev/null; then
  claude --version
  echo "Path: $(which claude)"
  count=$(which -a claude 2>/dev/null | wc -l | tr -d ' ')
  echo "Installations: $count"
  [ "$count" -gt 1 ] && echo "WARNING: Multiple installations found"
else
  echo "NOT INSTALLED"
fi

echo -e "\n=== npm Global (should be empty) ==="
if npm list -g @anthropic-ai/claude-code 2>/dev/null | grep -q claude-code; then
  echo "WARNING: Deprecated npm installation found"
  echo "Run: npm -g uninstall @anthropic-ai/claude-code"
else
  echo "None (correct)"
fi

echo -e "\n=== Config Files ==="
[ -f ~/.claude/claude_code_config.json ] && echo "✅ MCP config exists" || echo "❌ MCP config missing"
[ -f ~/.claude/settings.json ] && echo "✅ Settings exists" || echo "⚠️ Settings not created yet"
[ -f ~/.claude/CLAUDE.md ] && echo "✅ User memory exists" || echo "⚠️ User memory not set"

echo -e "\n=== MCP Servers ==="
if [ -f ~/.claude/claude_code_config.json ]; then
  if command -v jq &>/dev/null; then
    cat ~/.claude/claude_code_config.json | jq -r '.mcpServers | keys[]' 2>/dev/null || echo "None configured"
  else
    echo "Install jq for detailed MCP info"
  fi
else
  echo "No MCP config file"
fi

echo -e "\n=== Memory Rules ==="
if [ -d ~/.claude/rules ]; then
  ls ~/.claude/rules/*.md 2>/dev/null | wc -l | xargs echo "Rule files:"
else
  echo "No rules directory"
fi

echo -e "\n=== Done ==="
