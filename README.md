# AI Agent Error Prevention Guide

**Last Updated**: 2026-02-07
**Claude Code Version**: 2.1.34+
**Source**: [Official Claude Code Docs](https://code.claude.com/docs/en/setup)

A systematic guide to prevent common errors when working with AI coding agents.

---

## Why This Exists

AI agents make predictable, preventable mistakes:

| Error Type | Frequency | Impact |
|------------|-----------|--------|
| Summarizing instead of copying | Very High | Documentation drift |
| Translating without request | High | Information loss |
| Claiming "100% done" without verification | High | False confidence |
| Wrong config file paths | Medium | Setup failures |
| Duplicate installations (npm + native) | Medium | Version conflicts |

This guide provides **rules, scripts, and checklists** to eliminate these errors.

---

## Quick Start

```bash
# Clone
git clone https://github.com/MadKangYu/claude-error-prevention.git
cd claude-error-prevention

# Run verification
./scripts/verify-all.sh
```

---

## Part 1: Claude Code Installation (2026 Official)

### System Requirements

| Requirement | Specification |
|-------------|---------------|
| **macOS** | 13.0+ |
| **Windows** | 10 1809+ or Server 2019+ |
| **Linux** | Ubuntu 20.04+, Debian 10+, Alpine 3.19+ |
| **RAM** | 4 GB+ |
| **Network** | Internet required |
| **Shell** | Bash or Zsh recommended |

### Installation Methods

#### Native Install (Recommended)

**macOS, Linux, WSL:**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell:**
```powershell
irm https://claude.ai/install.ps1 | iex
```

**Windows CMD:**
```batch
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

#### Homebrew (macOS/Linux)
```bash
brew install --cask claude-code
```
> Note: Does NOT auto-update. Run `brew upgrade claude-code` manually.

#### WinGet (Windows)
```powershell
winget install Anthropic.ClaudeCode
```
> Note: Does NOT auto-update. Run `winget upgrade Anthropic.ClaudeCode` manually.

#### NPM (DEPRECATED)
```bash
# DEPRECATED - Do NOT use
npm install -g @anthropic-ai/claude-code
```
> **Warning**: NPM installation is deprecated. Migrate with `claude install`.
> **Never use** `sudo npm install -g` - causes permission issues.

### Post-Installation Verification

```bash
# 1. Check version
claude --version

# 2. Check installation path
which claude
# Expected: ~/.local/bin/claude (native)

# 3. Check for duplicates
which -a claude
# Should show only ONE path

# 4. Run doctor
claude doctor

# 5. Check for leftover npm installation
npm list -g @anthropic-ai/claude-code 2>/dev/null && echo "WARNING: Remove npm version"
```

### Remove Duplicate Installations

If you have both npm and native:
```bash
# Remove npm global installation
npm -g uninstall @anthropic-ai/claude-code

# Verify only native remains
which -a claude
```

### Release Channels

| Channel | Description |
|---------|-------------|
| `latest` | New features immediately (default) |
| `stable` | ~1 week old, skips buggy releases |

Install specific channel:
```bash
# Stable channel
curl -fsSL https://claude.ai/install.sh | bash -s stable

# Specific version
curl -fsSL https://claude.ai/install.sh | bash -s 2.1.34
```

Configure in settings:
```json
{
  "autoUpdatesChannel": "stable"
}
```

### Update Commands

```bash
# Auto-update (native only)
# Happens automatically in background

# Manual update
claude update

# Homebrew
brew upgrade claude-code

# WinGet
winget upgrade Anthropic.ClaudeCode
```

### Uninstall

**Native (macOS, Linux, WSL):**
```bash
rm -f ~/.local/bin/claude
rm -rf ~/.local/share/claude
```

**Native (Windows PowerShell):**
```powershell
Remove-Item -Path "$env:USERPROFILE\.local\bin\claude.exe" -Force
Remove-Item -Path "$env:USERPROFILE\.local\share\claude" -Recurse -Force
```

**Clean config (optional):**
```bash
rm -rf ~/.claude
rm ~/.claude.json
rm -rf .claude
rm -f .mcp.json
```

---

## Part 2: Configuration Paths (Critical)

### Correct Paths

| File | Location | Purpose |
|------|----------|---------|
| MCP Servers | `~/.claude/claude_code_config.json` | MCP server configuration |
| Settings | `~/.claude/settings.json` | User preferences |
| Project Settings | `.claude/settings.json` | Project-specific |
| Memory | `~/.claude/CLAUDE.md` | Persistent instructions |

### Wrong Paths (Common Mistakes)

```
❌ ~/.mcp.json (old/non-standard)
❌ ~/.config/claude/config.json
❌ ~/claude.json
❌ ./.mcp.json (project root)
```

### MCP Configuration Example

**Location**: `~/.claude/claude_code_config.json`

```json
{
  "mcpServers": {
    "agentation": {
      "command": "npx",
      "args": ["agentation-mcp", "server"]
    }
  }
}
```

---

## Part 3: Core Principles

### 1. Verbatim Copy

```
❌ AI rewrites: "No React data (keeps output minimal)" → "Minimal output"
✅ Exact copy:  "No React data (keeps output minimal)"
```

**Rule**: Official documentation must be copied exactly. No summarization, no translation.

### 2. Source of Truth Hierarchy

| Method | Trust | Use Case |
|--------|-------|----------|
| GitHub raw | 100% | Source code, docs |
| Official CLI output | 100% | Version, status |
| curl + html2text | 95% | HTML without AI |
| Playwright scrape | 90% | JS-rendered |
| WebFetch | 70% | Quick exploration only |
| Memory/assumptions | 0% | Never rely |

### 3. Verification Over Claims

```
❌ "Installation complete"
❌ "100% matches"
❌ "Everything correct"

✅ "Installed. `claude --version` → 2.1.34"
✅ "Compared with `diff`. Result: [output]"
✅ "Modified 3 files. `ls -la` shows: [output]"
```

**Rule**: Always show verification output.

### 4. No Assumptions

```
❌ Guessing config paths
❌ Assuming success
❌ Inferring intent

✅ Check official docs
✅ Run verification
✅ Ask when unclear
```

---

## Part 4: GitHub Raw Access

### Find Documentation Structure

```bash
# List repo contents
gh api repos/{owner}/{repo}/contents --jq '.[].name'

# List subdirectory
gh api repos/{owner}/{repo}/contents/docs --jq '.[].name'
```

### Get Raw Files

```bash
# Direct raw access
curl -s https://raw.githubusercontent.com/{owner}/{repo}/main/README.md

# Example: Claude Code README
curl -s https://raw.githubusercontent.com/anthropics/claude-code/main/README.md
```

### Compare Local vs Official

```bash
# Download official
curl -s https://raw.githubusercontent.com/{owner}/{repo}/main/docs/setup.md > /tmp/official.md

# Compare
diff local.md /tmp/official.md
```

---

## Part 5: npm/npx Verification

### After npm Install

```bash
verify_npm() {
  local pkg=$1

  # Check installed
  npm list "$pkg" --depth=0 || { echo "NOT INSTALLED"; return 1; }

  # Check peer deps
  npm ls "$pkg" 2>&1 | grep -i "peer dep" && echo "WARNING: peer dep issue"

  # Test execution
  npx "$pkg" --version 2>/dev/null || npx "$pkg" --help 2>/dev/null
}

verify_npm agentation
```

### npx Issues

```bash
# Force latest
npx --yes package@latest

# Clear cache
rm -rf ~/.npm/_npx

# Verify npx works
which npx && npx --version
```

---

## Part 6: Checklists

### Before Installation
- [ ] Check existing: `which -a [tool]`
- [ ] Read official docs (GitHub raw or code.claude.com)
- [ ] Note expected paths/versions

### After Installation
- [ ] Verify path: `which [tool]`
- [ ] Verify version: `[tool] --version`
- [ ] Check duplicates: `which -a [tool]`
- [ ] Test: `[tool] --help`
- [ ] Show actual output

### Before Documentation Work
- [ ] Find official source (GitHub structure)
- [ ] Verify raw access works
- [ ] Confirm: translation requested? (default: NO)

### After Documentation Work
- [ ] Run diff against source
- [ ] Document verification method
- [ ] Provide source URL
- [ ] Do NOT claim "100%"

---

## Part 7: Scripts

### verify-all.sh

```bash
#!/bin/bash
set -euo pipefail

echo "=== Claude Code ==="
if command -v claude &>/dev/null; then
  claude --version
  echo "Path: $(which claude)"
  echo "Duplicates: $(which -a claude | wc -l)"
else
  echo "NOT INSTALLED"
fi

echo -e "\n=== npm Global (should be empty) ==="
npm list -g @anthropic-ai/claude-code 2>/dev/null || echo "None (correct)"

echo -e "\n=== Config Files ==="
[ -f ~/.claude/claude_code_config.json ] && echo "✅ MCP config exists" || echo "❌ MCP config missing"
[ -f ~/.claude/settings.json ] && echo "✅ Settings exists" || echo "⚠️ Settings not created yet"

echo -e "\n=== MCP Servers ==="
if [ -f ~/.claude/claude_code_config.json ]; then
  cat ~/.claude/claude_code_config.json | jq -r '.mcpServers | keys[]' 2>/dev/null || echo "None configured"
fi
```

### verify-install.sh

```bash
#!/bin/bash
cmd=${1:?Usage: verify-install.sh <command>}

echo "=== Checking: $cmd ==="

# Path
if command -v "$cmd" &>/dev/null; then
  echo "Path: $(which "$cmd")"
else
  echo "ERROR: Not found in PATH"
  exit 1
fi

# Version
"$cmd" --version 2>/dev/null || "$cmd" -v 2>/dev/null || echo "Version: unknown"

# Duplicates
count=$(which -a "$cmd" 2>/dev/null | wc -l | tr -d ' ')
[ "$count" -gt 1 ] && echo "WARNING: $count installations found"

# Executable
"$cmd" --help &>/dev/null && echo "Executable: OK" || echo "Executable: FAILED"
```

### compare-docs.sh

```bash
#!/bin/bash
local_file=${1:?Usage: compare-docs.sh <local_file> <github_raw_url>}
github_url=${2:?Usage: compare-docs.sh <local_file> <github_raw_url>}

echo "Local:  $local_file"
echo "Remote: $github_url"

curl -s "$github_url" > /tmp/github_version

if diff -q "$local_file" /tmp/github_version &>/dev/null; then
  echo "✅ MATCH"
else
  echo "❌ DIFFERENT"
  echo "--- Diff (first 30 lines) ---"
  diff "$local_file" /tmp/github_version | head -30
fi
```

---

## Part 8: Integration

### For CLAUDE.md / Project Instructions

```markdown
## Rules

### Documentation
- Copy official docs verbatim (no summarization)
- Translate only when explicitly requested
- Verify against GitHub raw, not WebFetch
- Show verification output, never claim "100%"

### Installation
- Check existing installations first
- Use official methods only (native > homebrew > npm)
- Verify with actual command output
- Remove duplicates before installing

### Paths
- MCP config: ~/.claude/claude_code_config.json
- Settings: ~/.claude/settings.json
- Never use ~/.mcp.json
```

---

## Sources

- [Claude Code Official Docs](https://code.claude.com/docs/en/setup)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [Anthropic Discord](https://anthropic.com/discord)

---

## License

MIT License - Use freely, attribution appreciated.

---

**Remember**: Show verification output. Never claim "100%". When uncertain, verify or ask.
