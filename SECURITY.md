# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 3.x     | :white_check_mark: |
| 2.x     | :x:                |
| < 2.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

1. **DO NOT** create a public GitHub issue
2. Email the maintainer directly or use GitHub's private vulnerability reporting
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Security Best Practices (Documentation)

This repository contains error pattern documentation. The following security measures are implemented:

### What We DON'T Store

- ❌ Real API keys or tokens
- ❌ Personal file paths with usernames
- ❌ Actual credentials or passwords
- ❌ Private repository URLs
- ❌ Internal IP addresses or hostnames

### Placeholder Conventions

All examples use these safe placeholders:

| Type | Placeholder | Example |
|------|-------------|---------|
| API Keys | `sk-ant-...` or `sk-...` | `export ANTHROPIC_API_KEY=sk-ant-...` |
| Tokens | `<TOKEN>` or `<NEW_TOKEN>` | `--bot-token <NEW_TOKEN>` |
| Paths | `~/`, `/path/to/`, `$HOME` | `~/.config/opencode/` |
| URLs | `example.com`, `your-domain.com` | `https://your-domain.com/webhook` |
| IPs | `localhost`, `127.0.0.1` | `curl localhost:18789/health` |
| Users | Generic or `$USER` | `/Users/user/` not `/Users/realname/` |

### Documentation Security Checklist

Before committing documentation:

- [ ] No real API keys (search for `sk-ant-api`, `sk-proj-`, etc.)
- [ ] No real tokens (search for base64-like strings > 20 chars)
- [ ] No personal paths (search for `/Users/[a-z]`, `/home/[a-z]`)
- [ ] No internal URLs (search for internal domain patterns)
- [ ] No email addresses (except generic examples)
- [ ] Examples use `example.com` domain

### Automated Checks

The following patterns are blocked in CI:

```bash
# Pre-commit hook patterns (add to .git/hooks/pre-commit)
BLOCKED_PATTERNS=(
  'sk-ant-api[a-zA-Z0-9]'     # Real Anthropic API keys
  'sk-proj-[a-zA-Z0-9]'       # Real OpenAI project keys
  'ghp_[a-zA-Z0-9]{36}'       # GitHub Personal Access Tokens
  'gho_[a-zA-Z0-9]{36}'       # GitHub OAuth tokens
  'github_pat_[a-zA-Z0-9]'    # GitHub PATs (new format)
  '[0-9]{10}:[A-Za-z0-9_-]'   # Telegram bot tokens
  '@[a-z]+\.(com|net|org)'    # Email addresses
)
```

## Sensitive File Patterns

These files should NEVER be committed:

```gitignore
# Credentials
.env
.env.*
*.pem
*.key
credentials.json
auth.json
secrets.yaml

# Local configs with tokens
.claude/auth.json
.openclaw/agents/*/auth-profiles.json
.config/*/auth.json

# Session data
*.session
*.sqlite
```

## Tool-Specific Security

### Claude Code
- Auth stored in: `~/.config/claude-code/auth.json`
- Never share: OAuth tokens, session data

### OpenCode / Crush
- Config may contain API keys: `~/.config/opencode/opencode.json`
- Use environment variables instead: `$ANTHROPIC_API_KEY`

### OpenClaw
- Sensitive files:
  - `~/.openclaw/openclaw.json` - May contain tokens
  - `~/.openclaw/agents/*/auth-profiles.json` - OAuth tokens
- Set proper permissions: `chmod 600 ~/.openclaw/**/*.json`

### MCP Servers
- Never hardcode API keys in MCP config
- Use: `"env": { "API_KEY": "$API_KEY" }`
- Not: `"env": { "API_KEY": "sk-actual-key-here" }`

## Incident Response

If credentials are accidentally committed:

1. **Immediately rotate** the exposed credentials
2. Remove from git history:
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch <file>" \
     --prune-empty --tag-name-filter cat -- --all
   ```
3. Force push (coordinate with team)
4. Check for any unauthorized access in provider dashboards

## Contact

- GitHub: [@MadKangYu](https://github.com/MadKangYu)
- Security issues: Use GitHub's private vulnerability reporting

---

*Last updated: 2026-02-07*
