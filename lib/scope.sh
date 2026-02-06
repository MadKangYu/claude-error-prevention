#!/bin/bash
# lib/scope.sh - Scope detection

SCOPE_LIST=""

detect_scope() {
  SCOPE_LIST="global"

  # Claude Code
  command -v claude &>/dev/null && SCOPE_LIST="$SCOPE_LIST claude"

  # Crush / OpenCode
  command -v crush &>/dev/null && SCOPE_LIST="$SCOPE_LIST crush"
  command -v opencode &>/dev/null && SCOPE_LIST="$SCOPE_LIST opencode"

  # OpenClaw
  [[ -f ~/.openclaw/openclaw.json ]] && SCOPE_LIST="$SCOPE_LIST openclaw"

  # Obsidian / QMD
  command -v qmd &>/dev/null && SCOPE_LIST="$SCOPE_LIST obsidian"

  # Terminals
  [[ -d "/Applications/iTerm.app" ]] && SCOPE_LIST="$SCOPE_LIST iterm2"
  [[ -d "/Applications/Ghostty.app" ]] && SCOPE_LIST="$SCOPE_LIST ghostty"
  [[ -d "/Applications/Warp.app" ]] && SCOPE_LIST="$SCOPE_LIST warp"

  echo "$SCOPE_LIST"
}

is_scope_active() {
  echo "$SCOPE_LIST" | grep -qw "$1"
}

get_config_path() {
  case "$1" in
    claude)   echo "~/.claude/settings.json" ;;
    openclaw) echo "~/.openclaw/openclaw.json" ;;
    crush)    echo "~/.crush.json" ;;
    opencode) echo "~/.config/opencode/opencode.json" ;;
    *)        echo "unknown" ;;
  esac
}
