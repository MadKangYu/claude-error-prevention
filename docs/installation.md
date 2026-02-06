# Installation Guide (2026-02-07)

Verified against official GitHub sources.

---

## Claude Code

### Official Methods

**macOS/Linux (Recommended):**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Homebrew (macOS/Linux):**
```bash
brew install --cask claude-code
```

**Windows (Recommended):**
```powershell
irm https://claude.ai/install.ps1 | iex
```

**WinGet (Windows):**
```powershell
winget install Anthropic.ClaudeCode
```

**npm (DEPRECATED):**
```bash
# DO NOT USE - deprecated
npm install -g @anthropic-ai/claude-code
```

### Verification

```bash
claude --version          # Check version
which claude              # Expected: ~/.local/bin/claude
which -a claude           # Should show ONE path only
claude doctor             # Health check
```

### Remove Duplicates

```bash
npm -g uninstall @anthropic-ai/claude-code
which -a claude  # Verify single installation
```

### Update

```bash
claude update                              # Native
brew upgrade --cask claude-code            # Homebrew
winget upgrade Anthropic.ClaudeCode        # WinGet
```

### Release Channels

| Channel | Description |
|---------|-------------|
| `latest` | New features immediately |
| `stable` | ~1 week old, safer |

```bash
curl -fsSL https://claude.ai/install.sh | bash -s stable
```

**Source:** https://github.com/anthropics/claude-code/blob/main/README.md

---

## OpenCode → Crush (Renamed)

> **IMPORTANT:** OpenCode has been renamed to **Crush** by Charmbracelet.
> The old `opencode-ai/opencode` repo is archived.

### Official Methods

**Homebrew:**
```bash
brew install charmbracelet/tap/crush
```

**npm:**
```bash
npm install -g @charmland/crush
```

**Arch Linux:**
```bash
yay -S crush-bin
```

**Windows:**
```powershell
winget install charmbracelet.crush
# or
scoop bucket add charm https://github.com/charmbracelet/scoop-bucket.git
scoop install crush
```

### Legacy OpenCode (Archived)

If still using old OpenCode:

```bash
# Old installation (no longer maintained)
curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode/refs/heads/main/install | bash

# Homebrew (old)
brew install opencode-ai/tap/opencode
```

**Source:** https://github.com/charmbracelet/crush/blob/main/README.md

---

## QMD (Local Markdown Search)

### Official Method

**Bun (Recommended):**
```bash
bun install -g https://github.com/tobi/qmd
```

**Alternative:**
```bash
# If bun not installed
npm install -g bun
bun install -g https://github.com/tobi/qmd
```

### Setup

```bash
# Add collection
qmd collection add ~/Obsidian/Vault --name vault

# Generate embeddings
qmd embed

# Test search
qmd search "test"
```

### MCP Server

**Claude Code plugin (Recommended):**
```bash
claude marketplace add tobi/qmd
claude plugin add qmd@qmd
```

**Manual MCP config (`~/.claude/claude_code_config.json`):**
```json
{
  "mcpServers": {
    "qmd": {
      "command": "qmd",
      "args": ["mcp"]
    }
  }
}
```

**Source:** https://github.com/tobi/qmd/blob/main/README.md

---

## Verification Checklist

| Tool | Command | Expected |
|------|---------|----------|
| Claude Code | `claude --version` | Version number |
| Claude Code | `which -a claude` | Single path |
| Crush | `crush --version` | Version number |
| QMD | `qmd --version` | Version number |
| Bun | `bun --version` | Version number |
