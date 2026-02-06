# OpenClaw Error Patterns & Troubleshooting

> Comprehensive error patterns for OpenClaw - Telegram Bot Gateway for AI Agents

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗██╗      █████╗ ██╗    ██╗       ║
║  ██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝██║     ██╔══██╗██║    ██║       ║
║  ██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║     ██║     ███████║██║ █╗ ██║       ║
║  ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║     ██║     ██╔══██║██║███╗██║       ║
║  ╚██████╔╝██║     ███████╗██║ ╚████║╚██████╗███████╗██║  ██║╚███╔███╔╝       ║
║   ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝        ║
║                                                                              ║
║   Error Prevention System v3.0 | Patterns: 15 | Gateway Port: 18789          ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

**Version:** 2026.2.3+
**Architecture:** Telegram Bot → OpenClaw Gateway → AI Provider APIs

---

## Quick Reference

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                          OPENCLAW QUICK FIX                                  │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR                            │ QUICK FIX                                │
│  ─────────────────────────────────┼────────────────────────────────────────  │
│  "Unknown model: claude-opus-4-7" │ Use anthropic/claude-opus-4-6            │
│  "Connection refused :18789"      │ launchctl start openclaw.gateway         │
│  "Telegram webhook timeout"       │ Check gateway + bot token                │
│  "401 Unauthorized"               │ openclaw auth login anthropic            │
│  "429 Too Many Requests"          │ Wait or use fallback model               │
│  "Context window exceeded"        │ /compact or start new chat               │
│  "Agent not found"                │ openclaw agents list                     │
│  "Bot did not respond"            │ curl localhost:18789/health              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         OPENCLAW ARCHITECTURE                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌──────────────┐     ┌──────────────────┐     ┌──────────────────┐        │
│   │   Telegram   │────▶│  OpenClaw        │────▶│  AI Providers    │        │
│   │   Bot API    │     │  Gateway :18789  │     │  (Anthropic,     │        │
│   │              │◀────│                  │◀────│   OpenAI, etc)   │        │
│   └──────────────┘     └──────────────────┘     └──────────────────┘        │
│                               │                                             │
│                               ▼                                             │
│                        ┌──────────────────┐                                 │
│                        │  ~/.openclaw/    │                                 │
│                        │  ├── openclaw.json                                 │
│                        │  └── agents/                                       │
│                        │      ├── main/                                     │
│                        │      └── study/                                    │
│                        └──────────────────┘                                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Component Reference

| Component | Location/Port | Description |
|-----------|---------------|-------------|
| Gateway | `localhost:18789` | Main HTTP gateway server |
| Config | `~/.openclaw/openclaw.json` | Global configuration |
| Auth | `~/.openclaw/agents/*/auth-profiles.json` | OAuth tokens per agent |
| Logs | `openclaw logs --follow` | Real-time log streaming |
| Agents | `~/.openclaw/agents/` | Agent configurations |
| Browserless | `localhost:3000` | Optional browser automation |

---

## 1. Model Errors

### 1.1 Unknown Model

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ⚠️ Agent failed before reply: Unknown model: anthropic/claude-opus-4-7      │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Model ID typo or model not configured in OpenClaw

**Available Models:**

| Provider | Model ID | Alias |
|----------|----------|-------|
| Anthropic | `anthropic/claude-opus-4-6` | opus |
| Anthropic | `anthropic/claude-sonnet-4-5` | sonnet |
| Anthropic | `anthropic/claude-haiku-4-5` | haiku |
| OpenAI | `openai/gpt-5.3-codex` | codex |
| OpenAI | `openai/gpt-5.2` | gpt |
| Ollama | `ollama/llama3:latest` | local |

> Run `openclaw models` to see your configured models and aliases.

**Solution:**
```bash
# Check available models
openclaw models

# Update default model
openclaw config set defaultModel anthropic/claude-opus-4-6

# Set fallback models
openclaw config set fallbackModels '["anthropic/claude-sonnet-4-5", "anthropic/claude-haiku-4-5"]'
```

**Common Mistakes:**
- ❌ Typo in model version (e.g., `claude-opus-4-7`)
- ❌ `claude-4-opus` (wrong format)
- ❌ `anthropic/opus` (missing full name)
- ✅ `anthropic/claude-opus-4-6` (latest, Feb 2026)
- ✅ `anthropic/claude-opus-4-5` (legacy)

---

### 1.2 Model Not Authorized

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: Model anthropic/claude-opus-4-5 not authorized for this agent        │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Agent's models.json doesn't include the requested model

**Solution:**
```bash
# Check agent's allowed models
cat ~/.openclaw/agents/main/agent/models.json

# Add model to agent
openclaw agents config main --add-model anthropic/claude-opus-4-5

# Or edit directly
vim ~/.openclaw/agents/main/agent/models.json
```

---

## 2. Gateway Errors

### 2.1 Gateway Not Responding

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  curl: (7) Failed to connect to localhost port 18789: Connection refused    │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Diagnosis Flow:**
```
Gateway not responding?
       │
       ├─▶ Check if process running
       │        │
       │        └─▶ pgrep -f openclaw
       │
       ├─▶ Check port binding
       │        │
       │        └─▶ lsof -i :18789
       │
       └─▶ Check launchd status
                │
                └─▶ launchctl list | grep openclaw
```

**Solution:**
```bash
# Check gateway status
openclaw gateway status

# Start gateway (macOS)
launchctl start openclaw.gateway

# Or start manually
openclaw gateway start

# Restart if needed
openclaw gateway restart

# Check logs for errors
openclaw logs --follow
```

---

### 2.2 Port Already in Use

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: listen EADDRINUSE: address already in use :::18789                   │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Find process using port
lsof -i :18789

# Kill the process
kill -9 <PID>

# Or use fuser (Linux)
fuser -k 18789/tcp

# Restart gateway
openclaw gateway restart
```

---

### 2.3 Gateway Health Check

```bash
# Quick health check
curl -s http://localhost:18789/health | jq

# Expected response:
{
  "status": "healthy",
  "version": "2026.2.3",
  "uptime": 3600,
  "agents": ["main", "study"],
  "providers": {
    "anthropic": "connected",
    "openai": "connected"
  }
}

# Full diagnostics
openclaw doctor
```

---

## 3. Telegram Bot Errors

### 3.1 Webhook Timeout

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  [OpenClaw] Telegram webhook timeout                                         │
│  Error: Bot did not respond within 30s                                       │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Causes:**
1. Gateway is down
2. Bot token expired or invalid
3. Webhook URL misconfigured
4. AI provider timeout

**Diagnosis:**
```bash
# 1. Check gateway
curl -s http://localhost:18789/health

# 2. Verify bot token
openclaw agents list

# 3. Check webhook status
curl -s "https://api.telegram.org/bot<TOKEN>/getWebhookInfo" | jq

# 4. Check provider connectivity
openclaw providers status
```

**Solution:**
```bash
# If gateway down
openclaw gateway restart

# If token expired - regenerate at @BotFather
# Then update:
openclaw agents config main --bot-token <NEW_TOKEN>

# If webhook misconfigured
openclaw webhook set --agent main --url https://your-domain.com/webhook
```

---

### 3.2 Bot Not Responding to Messages

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Messages sent to bot, but no response received                              │
│  Bot shows "typing..." but never replies                                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Diagnosis:**
```bash
# Check logs for errors
openclaw logs --follow --agent main

# Test direct API call
curl -X POST http://localhost:18789/api/chat \
  -H "Content-Type: application/json" \
  -d '{"agent": "main", "message": "Hello"}'
```

**Common Causes:**
1. Rate limit exceeded on AI provider
2. Context window exceeded
3. Agent configuration error
4. Network connectivity issue

---

### 3.3 Unauthorized Chat Access

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: Chat ID 123456789 not authorized for agent 'main'                    │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Add authorized chat
openclaw agents config main --add-chat 123456789

# Or allow all chats (not recommended for production)
openclaw agents config main --allow-all-chats

# List authorized chats
openclaw agents config main --list-chats
```

---

## 4. Authentication Errors

### 4.1 OAuth Token Expired

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: 401 Unauthorized                                                     │
│  Provider: anthropic                                                         │
│  Message: Invalid or expired API key                                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Re-authenticate all providers
openclaw configure

# Or specific provider
openclaw auth login anthropic

# Verify authentication
openclaw auth status

# Check token expiry
cat ~/.openclaw/agents/main/agent/auth-profiles.json | jq '.anthropic.expiresAt'
```

---

### 4.2 API Key Not Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: No API key found for provider 'openai'                               │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Set API key via environment
export OPENAI_API_KEY=sk-...

# Or configure in OpenClaw
openclaw auth login openai --api-key sk-...

# Or add to config file
openclaw config set 'providers.openai.apiKey' 'sk-...'
```

---

## 5. Rate Limiting

### 5.1 Rate Limit Exceeded

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: 429 Too Many Requests                                                │
│  Retry-After: 60                                                             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Wait for rate limit reset (check Retry-After header)

# Configure fallback models for automatic failover
openclaw config set fallbackModels '["openai/gpt-5.2", "anthropic/claude-haiku-4-5"]'

# Enable automatic retry with backoff
openclaw config set 'rateLimit.autoRetry' true
openclaw config set 'rateLimit.maxRetries' 3
openclaw config set 'rateLimit.backoffMs' 1000
```

---

### 5.2 Context Window Exceeded

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: Context window exceeded (200K tokens)                                │
│  Current: 215,432 tokens                                                     │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# In Telegram chat:
/compact    # Summarize and reduce context

# Or start new conversation:
/new        # Clear context and start fresh

# Switch to model with larger context:
/model anthropic/claude-opus-4-5  # 200K context
```

---

## 6. Agent Configuration

### 6.1 Agent Not Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Error: Agent 'work' not found                                               │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# List available agents
openclaw agents list

# Create new agent
openclaw agents create work

# Clone from existing
openclaw agents clone main work
```

---

### 6.2 Agent Directory Structure

```
~/.openclaw/agents/
├── main/                    # Default agent
│   └── agent/
│       ├── auth-profiles.json   # OAuth tokens
│       ├── models.json          # Allowed models
│       ├── config.json          # Agent settings
│       └── history/             # Chat history
├── study/                   # Study agent
│   └── agent/
│       └── ...
└── work/                    # Work agent
    └── agent/
        └── ...
```

---

### 6.3 Agent Configuration Errors

| Error | Cause | Fix |
|-------|-------|-----|
| Agent not found | Wrong agent name | `openclaw agents list` |
| Auth failed | Profile missing | `openclaw auth login <provider>` |
| Model unavailable | Not in models.json | Add to agent's models.json |
| Permission denied | File permissions | `chmod 600 ~/.openclaw/agents/*/agent/*.json` |

---

## 7. Service Management

### 7.1 Service Status Check

```bash
# All services status
openclaw doctor

# Individual checks
curl -s http://localhost:18789/health | jq    # Gateway
curl -s http://localhost:3000 | head -1        # Browserless (if configured)

# launchd status (macOS)
launchctl list | grep openclaw
```

---

### 7.2 Service Errors

| Service | Port | Error | Fix |
|---------|------|-------|-----|
| Gateway | 18789 | Connection refused | `launchctl start openclaw.gateway` |
| Browserless | 3000 | Not running | `docker compose -f ~/.openclaw/docker-compose.browserless.yml up -d` |
| Redis | 6379 | Connection refused | `brew services start redis` |

---

### 7.3 Restart All Services

```bash
# Stop all
openclaw gateway stop
docker compose -f ~/.openclaw/docker-compose.browserless.yml down

# Start all
openclaw gateway start
docker compose -f ~/.openclaw/docker-compose.browserless.yml up -d

# Verify
openclaw doctor
```

---

## 8. Security

### 8.1 Sensitive Files

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SECURITY: SENSITIVE FILES                                                    │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  FILE                                    │ CONTAINS                          │
│  ────────────────────────────────────────┼─────────────────────────────────  │
│  ~/.openclaw/openclaw.json               │ May contain API tokens            │
│  ~/.openclaw/agents/*/auth-profiles.json │ OAuth tokens                      │
│  ~/.openclaw/.env                        │ Environment secrets               │
│                                                                              │
│  RECOMMENDED PERMISSIONS:                                                    │
│  chmod 600 ~/.openclaw/openclaw.json                                         │
│  chmod 600 ~/.openclaw/agents/*/agent/*.json                                 │
│  chmod 700 ~/.openclaw/agents/*/                                             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

### 8.2 Security Errors

| Error | Cause | Fix |
|-------|-------|-----|
| .env exposed | Committed to git | Add to .gitignore, rotate tokens |
| Token in logs | Logging not redacted | Set `logging.redact: true` |
| Insecure permissions | World-readable files | `chmod 600` on sensitive files |

---

### 8.3 Token Rotation

```bash
# Rotate Anthropic token
openclaw auth logout anthropic
openclaw auth login anthropic

# Rotate bot token (via @BotFather)
# 1. Message @BotFather
# 2. /revoke
# 3. Get new token
# 4. Update OpenClaw:
openclaw agents config main --bot-token <NEW_TOKEN>

# Verify all tokens
openclaw auth status
```

---

## 9. Logging & Debugging

### 9.1 Log Levels

```bash
# Set log level
openclaw config set 'logging.level' 'debug'

# Available levels: error, warn, info, debug, trace

# View logs
openclaw logs --follow

# Filter by agent
openclaw logs --follow --agent main

# Filter by level
openclaw logs --follow --level error
```

---

### 9.2 Debug Mode

```bash
# Enable debug mode
export OPENCLAW_DEBUG=1
openclaw gateway restart

# Or in config
openclaw config set 'debug' true

# View detailed request/response
openclaw logs --follow --level trace
```

---

## 10. Troubleshooting Flowchart

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      OPENCLAW TROUBLESHOOTING FLOW                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Error occurs                                                              │
│        │                                                                    │
│        ▼                                                                    │
│   ┌─────────────────┐                                                       │
│   │ Check logs      │                                                       │
│   │ openclaw logs   │                                                       │
│   └────────┬────────┘                                                       │
│            │                                                                │
│   ┌────────┼────────┬────────────┬────────────┐                             │
│   ▼        ▼        ▼            ▼            ▼                             │
│ ┌─────┐ ┌─────┐ ┌───────┐ ┌──────────┐ ┌──────────┐                         │
│ │Model│ │Auth │ │Gateway│ │ Telegram │ │  Rate    │                         │
│ │Error│ │Error│ │ Error │ │   Error  │ │  Limit   │                         │
│ └──┬──┘ └──┬──┘ └───┬───┘ └────┬─────┘ └────┬─────┘                         │
│    │       │        │          │            │                               │
│    ▼       ▼        ▼          ▼            ▼                               │
│ openclaw  openclaw  openclaw   Check       Wait or                          │
│ models    auth      gateway    webhook     use fallback                     │
│           login     restart    config      model                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 11. Configuration Reference

### 11.1 Main Config File

```json
// ~/.openclaw/openclaw.json
{
  "meta": {
    "lastTouchedVersion": "2026.2.3"
  },
  "gateway": {
    "port": 18789,
    "host": "localhost"
  },
  "defaultModel": "anthropic/claude-haiku-4-5",
  "fallbackModels": [
    "anthropic/claude-sonnet-4-5",
    "anthropic/claude-opus-4-6"
  ],
  "models": {
    "aliases": {
      "opus": "anthropic/claude-opus-4-6",
      "sonnet": "anthropic/claude-sonnet-4-5",
      "haiku": "anthropic/claude-haiku-4-5"
    }
  },
  "logging": {
    "level": "info",
    "redact": true
  },
  "rateLimit": {
    "autoRetry": true,
    "maxRetries": 3,
    "backoffMs": 1000
  }
}
```

---

### 11.2 Useful Commands

```bash
# Configuration
openclaw config get                    # Show all config
openclaw config set <key> <value>      # Set config value
openclaw config reset                  # Reset to defaults

# Models
openclaw models                        # List available models
openclaw models add <model-id>         # Add model
openclaw models remove <model-id>      # Remove model

# Agents
openclaw agents list                   # List agents
openclaw agents create <name>          # Create agent
openclaw agents delete <name>          # Delete agent
openclaw agents config <name>          # Configure agent

# Authentication
openclaw auth login <provider>         # Login to provider
openclaw auth logout <provider>        # Logout from provider
openclaw auth status                   # Show auth status

# Gateway
openclaw gateway start                 # Start gateway
openclaw gateway stop                  # Stop gateway
openclaw gateway restart               # Restart gateway
openclaw gateway status                # Show gateway status

# Diagnostics
openclaw doctor                        # Run diagnostics
openclaw logs --follow                 # Stream logs
openclaw version                       # Show version
```

---

## 12. Verification Script

```bash
#!/bin/bash
# openclaw-health-check.sh
# Comprehensive health check for OpenClaw

set -e

echo "=== OpenClaw Health Check ==="
echo ""

# 1. Check gateway
echo "1. Gateway Status:"
if curl -s http://localhost:18789/health > /dev/null 2>&1; then
    echo "   ✅ Gateway is running on port 18789"
    curl -s http://localhost:18789/health | jq -r '   Version: \(.version), Uptime: \(.uptime)s'
else
    echo "   ❌ Gateway is NOT running"
    echo "   Fix: openclaw gateway start"
fi
echo ""

# 2. Check config
echo "2. Configuration:"
if [ -f ~/.openclaw/openclaw.json ]; then
    echo "   ✅ Config file exists"
    VERSION=$(cat ~/.openclaw/openclaw.json | jq -r '.meta.lastTouchedVersion // "unknown"')
    echo "   Version: $VERSION"
else
    echo "   ❌ Config file missing"
    echo "   Fix: openclaw configure"
fi
echo ""

# 3. Check agents
echo "3. Agents:"
for agent_dir in ~/.openclaw/agents/*/; do
    agent_name=$(basename "$agent_dir")
    if [ -f "$agent_dir/agent/auth-profiles.json" ]; then
        echo "   ✅ $agent_name - configured"
    else
        echo "   ⚠️  $agent_name - missing auth"
    fi
done
echo ""

# 4. Check providers
echo "4. Provider Authentication:"
openclaw auth status 2>/dev/null || echo "   Run: openclaw auth status"
echo ""

# 5. Check logs for recent errors
echo "5. Recent Errors (last 10 lines):"
openclaw logs --limit 10 --level error 2>/dev/null || echo "   No recent errors"
echo ""

echo "=== Health Check Complete ==="
```

---

## 13. Self-Healing System (Karpathy Approach)

> *"에러 발생 후 고치지 말고, 발생 전에 막아라"* — Andrej Karpathy

### 13.1 Critical Discovery: False Positive OAuth Errors

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ⚠️ CRITICAL: OAuth errors are often FALSE POSITIVES!                         │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR SHOWN:                                                                │
│  FailoverError: OAuth token refresh failed for anthropic                     │
│                                                                              │
│  ACTUAL CAUSE:                                                               │
│  WebSocket channel is dead (HTTP may still be OK)                            │
│                                                                              │
│  DIAGNOSTIC ORDER (MECE):                                                    │
│  1. Process: launchctl list | grep openclaw                                  │
│  2. HTTP: curl -sf http://localhost:18789/health                             │
│  3. WS: timeout 5 openclaw gateway health                                    │
│                                                                              │
│  If HTTP OK but WS fails → Gateway restart needed                            │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

### 13.2 WebSocket vs HTTP

| Protocol | Type | Behavior | Check Command |
|----------|------|----------|---------------|
| HTTP | Stateless | Each request independent | `curl -sf localhost:18789/health` |
| WebSocket | Stateful | Connection state maintained | `timeout 5 openclaw gateway health` |

**Why HTTP OK but WS fails:**
- HTTP handler and WS handler are separate
- Long-running Gateway → WS handler can become unstable
- HTTP continues working, but WS channel is dead

---

### 13.3 Reliable Gateway Restart

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ❌ UNRELIABLE: openclaw gateway restart                                      │
│    - Returns "succeeded" but may not actually restart                        │
│    - Fails silently when service is unloaded                                 │
│                                                                              │
│ ✅ RELIABLE: launchctl unload && load                                        │
│    - Always works                                                            │
│    - Verified through actual testing                                         │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Reliable restart command:**
```bash
launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.plist 2>/dev/null
sleep 2
launchctl load ~/Library/LaunchAgents/ai.openclaw.gateway.plist
```

---

### 13.4 Automated Self-Healing Setup

**Health Check Script:** `~/.claude/scripts/openclaw-healthcheck.sh`

```bash
#!/bin/bash
# OpenClaw Self-Healing (10-minute interval via launchd)

LOG_FILE="$HOME/.cache/openclaw-health/health.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

# MECE Layer checks
check_process() {
    launchctl list 2>/dev/null | grep -q "ai.openclaw.gateway"
}

check_http() {
    curl -sf http://127.0.0.1:18789/health >/dev/null 2>&1
}

check_ws() {
    timeout 10 openclaw gateway health >/dev/null 2>&1
}

recover() {
    log "🔄 Auto-recovering Gateway..."
    launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.plist 2>/dev/null
    sleep 2
    launchctl load ~/Library/LaunchAgents/ai.openclaw.gateway.plist
    
    for i in 5 10 15 20 25 30; do
        sleep 5
        if check_http && check_ws; then
            log "✅ Recovery success (${i}s)"
            return 0
        fi
    done
    log "❌ Recovery failed"
    return 1
}

# Main
log "--- Health Check ---"
check_process || { log "❌ Process down"; recover; exit $?; }
check_http    || { log "❌ HTTP down"; recover; exit $?; }
check_ws      || { log "❌ WS down"; recover; exit $?; }
log "✅ All healthy"
```

**launchd plist:** `~/Library/LaunchAgents/com.kangyu.openclaw-healthcheck.plist`

---

### 13.5 Lessons Learned

| Lesson | Description |
|--------|-------------|
| **HTTP OK ≠ System OK** | HTTP stateless, WS stateful - check both |
| **Error messages lie** | OAuth error was actually WS dead |
| **Timeout increase doesn't help** | If time isn't the problem |
| **Official commands can fail** | `openclaw gateway restart` vs `launchctl load` |
| **Test, don't assume** | "Should work" ≠ "Does work" |

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [Claude Code Errors](./claude-code-errors.md) | Claude Code CLI errors |
| [OpenCode Errors](./opencode-errors.md) | OpenCode/Crush CLI errors |
| [Oh My OpenCode Errors](./oh-my-opencode-errors.md) | Plugin errors |
| [Obsidian Errors](./obsidian-errors.md) | PKM integration |
| [Ghostty Errors](./ghostty-errors.md) | Terminal emulator |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.0 | 2026-02-07 | Complete rewrite with 15 patterns, architecture diagrams |
| 2.0 | 2026-02-03 | Initial documentation |

---

*Last updated: 2026-02-07 | Maintainer: claude-error-prevention | License: MIT*
