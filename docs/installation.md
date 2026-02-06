# Installation Rules (2026-02-07)

## Claude Code

### Official Method (Native)

**macOS, Linux, WSL:**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell:**
```powershell
irm https://claude.ai/install.ps1 | iex
```

### Deprecated (Do NOT Use)
```bash
# DEPRECATED
npm install -g @anthropic-ai/claude-code

# NEVER use sudo
sudo npm install -g  # DANGEROUS
```

### Post-Install Verification
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

## Release Channels

| Channel | Description |
|---------|-------------|
| `latest` | New features immediately |
| `stable` | ~1 week old, safer |

```bash
# Install stable
curl -fsSL https://claude.ai/install.sh | bash -s stable
```

## Update Commands

```bash
claude update                              # Native
brew upgrade claude-code                   # Homebrew
winget upgrade Anthropic.ClaudeCode        # WinGet
```

## npm/npx Verification

```bash
# After npm install
npm list <package> --depth=0
npm ls <package> 2>&1 | grep "peer dep"

# Force latest
npx --yes <package>@latest

# Clear cache if issues
rm -rf ~/.npm/_npx
```
