# Claude Doctor Reference

> `claude doctor` diagnostic command reference.
> Source: code.claude.com/docs/en/troubleshooting

---

## Running Doctor

```bash
claude doctor
```

**Note:** Requires TTY (interactive terminal). Won't work in CI/CD or piped environments.

---

## Checks Performed

| Check | Description | Common Issues |
|-------|-------------|---------------|
| **Installation** | Binary location, permissions | Multiple installs |
| **Authentication** | OAuth token validity | Token expired |
| **Network** | API connectivity | Firewall, proxy |
| **Configuration** | Settings file validity | JSON syntax error |
| **MCP Servers** | Server connectivity | Path errors, timeouts |
| **Permissions** | File/directory access | Permission denied |

---

## Sample Output

```
Claude Code Doctor
==================

✓ Installation
  Binary: ~/.local/bin/claude
  Version: 2.1.34

✓ Authentication
  Method: OAuth
  Account: user@example.com
  Org: Default

✓ Network
  API: Connected
  Latency: 45ms

✓ Configuration
  User settings: Valid
  Project settings: Valid

✓ MCP Servers
  qmd: Connected
  github: Connected

All checks passed!
```

---

## Common Errors

### 1. Multiple Installations

```
⚠ Multiple claude binaries found:
  - ~/.local/bin/claude
  - /usr/local/bin/claude
```

**Fix:**
```bash
npm uninstall -g @anthropic-ai/claude-code
which -a claude  # Verify single installation
```

### 2. OAuth Token Expired

```
✗ Authentication
  Error: OAuth token expired
```

**Fix:**
```bash
claude login
```

### 3. MCP Server Failed

```
✗ MCP Servers
  qmd: Connection failed (spawn ENOENT)
```

**Fix:**
- Use absolute paths in MCP config
- Verify MCP server binary exists
- Check `which qmd`

### 4. Settings Invalid

```
✗ Configuration
  User settings: Invalid JSON at line 15
```

**Fix:**
```bash
# Validate
jq empty ~/.claude/settings.json

# Fix or reset
echo '{}' > ~/.claude/settings.json
```

---

## Non-Interactive Alternatives

When `claude doctor` fails (non-TTY environment):

```bash
# Manual checks
echo "=== Installation ==="
claude --version
which -a claude

echo "=== Authentication ==="
# Check if logged in
cat ~/.claude.json | jq '.oauthAccount // "Not logged in"'

echo "=== Configuration ==="
jq empty ~/.claude/settings.json && echo "Settings: Valid"
jq empty .claude/settings.json 2>/dev/null && echo "Project settings: Valid"

echo "=== MCP Servers ==="
cat ~/.claude.json | jq '.mcpServers | keys'
```

---

## Automated Health Check Script

```bash
#!/bin/bash
# claude-health-check.sh

echo "Claude Code Health Check"
echo "========================"

# Installation
echo -n "Installation: "
if command -v claude &>/dev/null; then
    echo "OK ($(claude --version 2>&1 | head -1))"
else
    echo "NOT FOUND"
fi

# Multiple installations
echo -n "Single Install: "
count=$(which -a claude 2>/dev/null | wc -l)
if [[ $count -eq 1 ]]; then
    echo "OK"
elif [[ $count -gt 1 ]]; then
    echo "WARNING ($count installations)"
else
    echo "NOT FOUND"
fi

# Settings
echo -n "User Settings: "
if jq empty ~/.claude/settings.json 2>/dev/null; then
    echo "OK"
else
    echo "INVALID or MISSING"
fi

# Global CLAUDE.md
echo -n "Global CLAUDE.md: "
if [[ -f ~/.claude/CLAUDE.md ]]; then
    echo "OK"
else
    echo "MISSING"
fi

# Skills
echo -n "Skills: "
count=$(ls ~/.claude/skills/ 2>/dev/null | wc -l)
echo "$count installed"

# API Key
echo -n "ANTHROPIC_API_KEY: "
if [[ -n "$ANTHROPIC_API_KEY" ]]; then
    echo "SET"
else
    echo "NOT SET"
fi

echo "========================"
echo "Done"
```

---

## See Also

- [Troubleshooting](../errors/claude-code-errors.md)
- [Configuration](../config/file-locations.md)
- [Environment Variables](../config/environment-vars.md)

---

*Last updated: 2026-02-07*
*Source: code.claude.com/docs/en/troubleshooting*
