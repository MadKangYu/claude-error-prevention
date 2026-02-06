# Installation Guide (2026-02-07)

> Verified against official GitHub sources and documentation.
> Sources: code.claude.com, github.com/charmbracelet/crush, github.com/tobi/qmd

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

**Windows PowerShell (Recommended):**
```powershell
irm https://claude.ai/install.ps1 | iex
```

**Windows CMD:**
```batch
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
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

### Version Installation

```bash
# Install latest (default)
curl -fsSL https://claude.ai/install.sh | bash

# Install stable version (~1 week old, fewer bugs)
curl -fsSL https://claude.ai/install.sh | bash -s stable

# Install specific version
curl -fsSL https://claude.ai/install.sh | bash -s 1.0.58
```

**Windows PowerShell:**
```powershell
# Latest
irm https://claude.ai/install.ps1 | iex

# Stable
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) stable

# Specific version
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) 1.0.58
```

### Platform-Specific Notes

**Windows:**
- Requires [Git for Windows](https://git-scm.com/downloads/win) (includes Git Bash)
- If Git installed in custom location: `$env:CLAUDE_CODE_GIT_BASH_PATH="C:\Program Files\Git\bin\bash.exe"`

**Alpine Linux (musl/uClibc):**
```bash
# Required dependencies
apk add libgcc libstdc++ ripgrep

# Then install
curl -fsSL https://claude.ai/install.sh | bash

# Set environment
export USE_BUILTIN_RIPGREP=0
```

**WSL:**
- WSL1: Limited support, no sandboxing
- WSL2: Full support including sandboxing
- Sandbox deps: `sudo apt-get install bubblewrap socat`

### Verification

```bash
claude --version          # Check version
which claude              # Expected: ~/.local/bin/claude
which -a claude           # Should show ONE path only
claude doctor             # Health check
```

### Update

```bash
claude update                              # Native (auto-updates by default)
brew upgrade --cask claude-code            # Homebrew
winget upgrade Anthropic.ClaudeCode        # WinGet
```

**Disable auto-updates:**
```bash
export DISABLE_AUTOUPDATER=1
```

### Release Channels

| Channel | Description |
|---------|-------------|
| `latest` | New features immediately (default) |
| `stable` | ~1 week old, skips major regressions |

Configure in settings.json:
```json
{
  "autoUpdatesChannel": "stable"
}
```

### Remove Duplicates

```bash
npm -g uninstall @anthropic-ai/claude-code
which -a claude  # Verify single installation
```

### Uninstall

**Native installation:**
```bash
# macOS/Linux/WSL
rm -f ~/.local/bin/claude
rm -rf ~/.local/share/claude

# Windows PowerShell
Remove-Item -Path "$env:USERPROFILE\.local\bin\claude.exe" -Force
Remove-Item -Path "$env:USERPROFILE\.local\share\claude" -Recurse -Force
```

**Package managers:**
```bash
brew uninstall --cask claude-code          # Homebrew
winget uninstall Anthropic.ClaudeCode      # WinGet
npm uninstall -g @anthropic-ai/claude-code # npm
```

**Clean configuration (optional):**
```bash
rm -rf ~/.claude
rm ~/.claude.json
rm -rf .claude/
rm -f .mcp.json
```

**Source:** https://code.claude.com/docs/en/setup

---

## Crush (Charmbracelet)

> Terminal-based AI coding assistant. Part of the Charm ecosystem.

### Official Methods

**Homebrew (macOS/Linux):**
```bash
brew install charmbracelet/tap/crush
```

**npm:**
```bash
npm install -g @charmland/crush
```

**Debian/Ubuntu:**
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install crush
```

**Fedora/RHEL:**
```bash
echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
sudo yum install crush
```

**Arch Linux:**
```bash
yay -S crush-bin
```

**Windows:**
```powershell
# WinGet
winget install charmbracelet.crush

# Scoop
scoop bucket add charm https://github.com/charmbracelet/scoop-bucket.git
scoop install crush
```

**Nix:**
```bash
nix run github:numtide/nix-ai-tools#crush
```

**FreeBSD:**
```bash
pkg install crush
```

**Go:**
```bash
go install github.com/charmbracelet/crush@latest
```

**Binary downloads:**
- [GitHub Releases](https://github.com/charmbracelet/crush/releases)
- Available for: Linux, macOS, Windows, FreeBSD, OpenBSD, NetBSD

### Legacy OpenCode (Archived)

> Note: OpenCode (anomalyco/opencode) is a SEPARATE project, still maintained.

If using old opencode-ai package:
```bash
# Uninstall old
npm uninstall -g opencode-ai
brew uninstall opencode-ai/tap/opencode 2>/dev/null

# Install Crush
brew install charmbracelet/tap/crush
```

**Source:** https://github.com/charmbracelet/crush/blob/main/README.md

---

## OpenCode (anomalyco)

> Different project from Crush. TypeScript-based AI coding assistant.

### Official Methods

**Quick install:**
```bash
curl -fsSL https://opencode.ai/install | bash
```

**npm:**
```bash
npm i -g opencode-ai@latest
```

**Homebrew:**
```bash
brew install anomalyco/tap/opencode
```

**Windows:**
```bash
scoop install opencode
```

**Source:** https://github.com/anomalyco/opencode

---

## QMD (Local Markdown Search)

> On-device search engine for markdown notes. BM25 + vector + LLM reranking.

### System Requirements

**macOS:**
```bash
# Required for SQLite extension support
brew install sqlite
```

**Bun (required):**
```bash
# If not installed
npm install -g bun
```

### Official Method

```bash
bun install -g https://github.com/tobi/qmd
```

Ensure `~/.bun/bin` is in PATH.

### Setup

```bash
# Add collections
qmd collection add ~/notes --name notes
qmd collection add ~/Obsidian/Vault --name vault

# Add context (helps search)
qmd context add qmd://notes "Personal notes and ideas"
qmd context add qmd://vault "Obsidian knowledge base"

# Generate embeddings (first time takes longer)
qmd embed

# Verify
qmd status
```

### Search Modes

| Command | Description | Speed |
|---------|-------------|-------|
| `qmd search` | BM25 keyword search | Fast |
| `qmd vsearch` | Semantic vector search | Medium |
| `qmd query` | Hybrid + reranking | Best quality |

```bash
# Examples
qmd search "project timeline"           # Keyword search
qmd vsearch "how to deploy"             # Semantic search
qmd query "quarterly planning"          # Best quality

# Options
qmd search -n 10 "query"                # 10 results
qmd search -c notes "query"             # Search specific collection
qmd search --json "query"               # JSON output
qmd search --files --min-score 0.3 "q"  # Files with score > 0.3
```

### Collection Management

```bash
qmd collection list              # List all
qmd collection add ~/path --name myname
qmd collection remove myname
qmd collection rename old new
qmd ls notes                     # List files in collection
```

### MCP Server

**Claude Code plugin (Recommended):**
```bash
claude marketplace add tobi/qmd
claude plugin add qmd@qmd
```

**Claude Desktop (`~/Library/Application Support/Claude/claude_desktop_config.json`):**
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

**Claude Code manual (`~/.claude/settings.json`):**
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

**MCP Tools exposed:**
- `qmd_search` - BM25 keyword search
- `qmd_vsearch` - Semantic vector search
- `qmd_query` - Hybrid search with reranking
- `qmd_get` - Retrieve document by path/docid
- `qmd_multi_get` - Get multiple documents
- `qmd_status` - Index health info

**Source:** https://github.com/tobi/qmd/blob/main/README.md

---

## Verification Checklist

| Tool | Command | Expected |
|------|---------|----------|
| Claude Code | `claude --version` | Version number |
| Claude Code | `which -a claude` | Single path |
| Claude Code | `claude doctor` | All checks pass |
| Crush | `crush --version` | Version number |
| OpenCode | `opencode --version` | Version number |
| QMD | `qmd --version` | Version number |
| QMD | `qmd status` | Collections listed |
| Bun | `bun --version` | Version number |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 4.0 | 2026-02-07 | Complete rewrite from official docs |
| 3.0 | 2026-02-06 | Initial version |

---

*Last updated: 2026-02-07*
*Sources: code.claude.com/docs/en/setup, github.com/charmbracelet/crush, github.com/tobi/qmd*
