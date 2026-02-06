# OpenClaw Error Patterns

**Version:** 2026.2.3+

---

## Quick Reference

| Component | Location/Port |
|-----------|---------------|
| Gateway | `localhost:18789` |
| Config | `~/.openclaw/openclaw.json` |
| Auth | `~/.openclaw/agents/main/agent/auth-profiles.json` |
| Logs | `openclaw logs --follow` |

---

## Common Errors

### 1. Unknown Model

```
⚠️ Agent failed before reply: Unknown model: anthropic/claude-opus-4-6
```

**Cause:** Model ID typo or model not configured

**Available Models:**
```
anthropic/claude-opus-4-5
anthropic/claude-sonnet-4-5
anthropic/claude-haiku-4-5
openai/gpt-5.2
github-copilot/gpt-5.2-codex
google-antigravity/claude-sonnet-4-5
```

**Fix:**
```bash
# Check available models
openclaw models

# Update config
openclaw config set defaultModel anthropic/claude-opus-4-5
```

---

### 2. Gateway Not Responding

```
curl: (7) Failed to connect to localhost port 18789: Connection refused
```

**Fix:**
```bash
# Check status
openclaw gateway status

# Start gateway
launchctl start openclaw.gateway

# Or restart
openclaw gateway restart
```

---

### 3. Telegram Bot No Response

```
[OpenClaw] Telegram webhook timeout
Error: Bot did not respond within 30s
```

**Causes:**
- Gateway down
- Bot token expired
- Webhook misconfigured

**Fix:**
```bash
# Check gateway
curl -s http://localhost:18789/health

# Verify bot token
openclaw agents list

# Regenerate token at @BotFather if needed
```

---

### 4. OAuth Token Expired

```
Error: 401 Unauthorized
Provider: anthropic
```

**Fix:**
```bash
# Re-authenticate
openclaw configure

# Or specific provider
openclaw auth login anthropic
```

---

### 5. Rate Limit Exceeded

```
Error: 429 Too Many Requests
```

**Fix:**
- Wait for rate limit reset
- Use fallback model:
```bash
openclaw config set fallbackModels '["openai/gpt-5.2", "anthropic/claude-haiku-4-5"]'
```

---

### 6. Context Window Exceeded

```
Error: Context window exceeded (200K tokens)
```

**Fix:**
- Use `/compact` in chat
- Switch to model with larger context
- Start new conversation

---

## Model Configuration

### Check Current Config
```bash
openclaw models
```

**Output:**
```
Default       : anthropic/claude-haiku-4-5
Fallbacks (2) : anthropic/claude-sonnet-4-5, anthropic/claude-opus-4-5
Aliases (9)   : opus -> anthropic/claude-opus-4-5, ...
```

### Model Aliases

| Alias | Model ID |
|-------|----------|
| opus | anthropic/claude-opus-4-5 |
| sonnet | anthropic/claude-sonnet-4-5 |
| haiku | anthropic/claude-haiku-4-5 |
| gpt | openai/gpt-5.2 |
| codex | github-copilot/gpt-5.2-codex |
| free | ollama/llama3.2:3b |

### Set Model
```bash
# Set default
openclaw config set defaultModel anthropic/claude-opus-4-5

# Set fallbacks
openclaw config set fallbackModels '["anthropic/claude-sonnet-4-5"]'

# Add alias
openclaw config set 'models.aliases.mymodel' 'anthropic/claude-opus-4-5'
```

---

## Agent Configuration

### List Agents
```bash
openclaw agents list
```

### Agent Structure
```
~/.openclaw/agents/
├── main/           # Default agent
│   └── agent/
│       ├── auth-profiles.json
│       └── models.json
├── study/
└── ...
```

### Agent Errors

| Error | Cause | Fix |
|-------|-------|-----|
| Agent not found | Wrong agent name | `openclaw agents list` |
| Auth failed | Profile missing | `openclaw auth login <provider>` |
| Model unavailable | Not configured | Add to models.json |

---

## Services

### Health Checks
```bash
# Gateway
curl -s http://localhost:18789/health | jq

# Browserless (if configured)
curl -s http://localhost:3000

# All services
openclaw doctor
```

### Service Errors

| Service | Port | Error | Fix |
|---------|------|-------|-----|
| Gateway | 18789 | Connection refused | `launchctl start openclaw.gateway` |
| Browserless | 3000 | Not running | `docker compose -f ~/.openclaw/docker-compose.browserless.yml up -d` |

---

## Security

### Sensitive Files
```
~/.openclaw/openclaw.json          # May contain tokens
~/.openclaw/agents/*/auth-profiles.json  # OAuth tokens
```

### Security Errors

| Error | Cause | Fix |
|-------|-------|-----|
| .env exposed | Committed to git | Add to .gitignore, rotate tokens |
| Token in logs | Logging not redacted | Set `logging.redact: true` |

---

## Verification

```bash
# Full health check
openclaw doctor

# Config validation
cat ~/.openclaw/openclaw.json | jq '.meta.lastTouchedVersion'

# Provider auth status
openclaw models  # Shows auth overview

# Logs
openclaw logs --follow
```

---

## Troubleshooting Flowchart

```
Error occurs
    │
    ▼
┌─────────────────┐
│ Check logs      │
│ openclaw logs   │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌───────┐ ┌───────┐
│ Model │ │ Auth  │
│ Error │ │ Error │
└───┬───┘ └───┬───┘
    │         │
    ▼         ▼
openclaw   openclaw
models     auth login
```
