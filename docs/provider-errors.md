# API Provider Error Patterns & Troubleshooting

> Error patterns for OpenAI, Anthropic, Google, and other LLM API providers

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   █████╗ ██████╗ ██╗    ██████╗ ██████╗  ██████╗ ██╗   ██╗██╗██████╗ ███████╗║
║  ██╔══██╗██╔══██╗██║    ██╔══██╗██╔══██╗██╔═══██╗██║   ██║██║██╔══██╗██╔════╝║
║  ███████║██████╔╝██║    ██████╔╝██████╔╝██║   ██║██║   ██║██║██║  ██║█████╗  ║
║  ██╔══██║██╔═══╝ ██║    ██╔═══╝ ██╔══██╗██║   ██║╚██╗ ██╔╝██║██║  ██║██╔══╝  ║
║  ██║  ██║██║     ██║    ██║     ██║  ██║╚██████╔╝ ╚████╔╝ ██║██████╔╝███████╗║
║  ╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═════╝ ╚══════╝║
║              ███████╗██████╗ ██████╗  ██████╗ ██████╗ ███████╗               ║
║              ██╔════╝██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔════╝               ║
║              █████╗  ██████╔╝██████╔╝██║   ██║██████╔╝███████╗               ║
║              ██╔══╝  ██╔══██╗██╔══██╗██║   ██║██╔══██╗╚════██║               ║
║              ███████╗██║  ██║██║  ██║╚██████╔╝██║  ██║███████║               ║
║              ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝               ║
║                                                                              ║
║   Error Prevention System v3.0 | Patterns: 15 | Multi-Provider Coverage     ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Official Documentation Sources

| Provider | Status Page | API Docs |
|----------|-------------|----------|
| Anthropic | https://status.anthropic.com | https://docs.anthropic.com |
| OpenAI | https://status.openai.com | https://platform.openai.com/docs |
| Google | https://status.cloud.google.com | https://ai.google.dev/docs |
| OpenRouter | https://status.openrouter.ai | https://openrouter.ai/docs |

---

## Quick Reference

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                       API PROVIDER QUICK FIX                                 │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR CODE                       │ QUICK FIX                                │
│  ─────────────────────────────────┼────────────────────────────────────────  │
│  401 Unauthorized                 │ Check API key format and validity        │
│  403 Forbidden                    │ Check account permissions/billing        │
│  429 Too Many Requests            │ Wait and retry with exponential backoff  │
│  500 Internal Server Error        │ Retry, check status page                 │
│  502 Bad Gateway                  │ Provider outage, wait and retry          │
│  503 Service Unavailable          │ Check status page, switch provider       │
│  529 Overloaded                   │ High demand, retry with backoff          │
│  context_length_exceeded          │ Reduce input tokens                      │
│  rate_limit_exceeded              │ Reduce request frequency                 │
│  invalid_api_key                  │ Regenerate API key                       │
│  insufficient_quota               │ Add credits or upgrade plan              │
│  model_not_found                  │ Check model name spelling/availability   │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Provider Comparison

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                       PROVIDER COMPARISON                                    │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Provider    │ Rate Limit  │ Context    │ Key Format                        │
│  ────────────┼─────────────┼────────────┼─────────────────────────────────  │
│  Anthropic   │ Tier-based  │ 200K-1M    │ sk-ant-api03-...                  │
│  OpenAI      │ TPM/RPM     │ 8K-128K    │ sk-proj-... or sk-...             │
│  Google      │ QPM         │ 32K-2M     │ AIza...                           │
│  OpenRouter  │ Per-model   │ Varies     │ sk-or-v1-...                      │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Anthropic (Claude) Errors

### 401: Invalid API Key

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "type": "error",                                                          │
│    "error": {                                                                │
│      "type": "authentication_error",                                         │
│      "message": "Invalid API Key"                                            │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**
1. Verify key format: `sk-ant-api03-...`
2. Regenerate key at console.anthropic.com
3. Check environment variable:
```bash
echo $ANTHROPIC_API_KEY | head -c 20
# Should show: sk-ant-api03-...
```

---

### 429: Rate Limited

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "type": "error",                                                          │
│    "error": {                                                                │
│      "type": "rate_limit_error",                                             │
│      "message": "Rate limit exceeded"                                        │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Anthropic Rate Limits by Tier:**

| Tier | RPM | TPM | Upgrade Path |
|------|-----|-----|--------------|
| Free | 5 | 20K | Add payment |
| Build (Tier 1) | 50 | 40K | Spend $5 |
| Build (Tier 2) | 1000 | 80K | Spend $40 |
| Build (Tier 3) | 2000 | 160K | Spend $200 |
| Build (Tier 4) | 4000 | 400K | Spend $1000 |
| Scale | Custom | Custom | Contact sales |

**Solutions:**
1. Wait for reset (usually 1 minute)
2. Implement exponential backoff:
```typescript
const delay = Math.min(1000 * Math.pow(2, attempt), 60000);
await new Promise(r => setTimeout(r, delay));
```
3. Upgrade tier

---

### 529: Overloaded

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "type": "error",                                                          │
│    "error": {                                                                │
│      "type": "overloaded_error",                                             │
│      "message": "Overloaded"                                                 │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** High API demand, especially during peak hours.

**Solutions:**
1. Retry with exponential backoff (30s base)
2. Switch to less popular model temporarily
3. Check status.anthropic.com

---

### Context Length Exceeded

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "type": "error",                                                          │
│    "error": {                                                                │
│      "type": "invalid_request_error",                                        │
│      "message": "prompt is too long: 250000 tokens > 200000 maximum"         │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Claude Context Limits (Feb 2026):**

| Model | Context Window |
|-------|----------------|
| claude-opus-4-6 | 200K |
| claude-sonnet-4-5 | 200K |
| claude-haiku-4-5 | 200K |

**Solutions:**
1. Summarize conversation history
2. Remove older messages
3. Use RAG instead of full documents
4. Split into multiple requests

---

## OpenAI Errors

### Invalid API Key

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "error": {                                                                │
│      "message": "Incorrect API key provided",                                │
│      "type": "invalid_request_error",                                        │
│      "code": "invalid_api_key"                                               │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**OpenAI Key Formats:**
- Project keys: `sk-proj-...` (recommended)
- User keys: `sk-...` (legacy)

**Solutions:**
1. Verify key at platform.openai.com/api-keys
2. Check project permissions
3. Regenerate if compromised

---

### Insufficient Quota

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "error": {                                                                │
│      "message": "You exceeded your current quota",                           │
│      "type": "insufficient_quota",                                           │
│      "code": "insufficient_quota"                                            │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**
1. Add credits: platform.openai.com/account/billing
2. Check usage: platform.openai.com/usage
3. Set usage limits to prevent overruns

---

### Model Not Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "error": {                                                                │
│      "message": "The model 'gpt-5.3-codex' does not exist",                  │
│      "type": "invalid_request_error",                                        │
│      "code": "model_not_found"                                               │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Available Models (Feb 2026):**

| Model | Context | Notes |
|-------|---------|-------|
| gpt-5.3-codex | 128K | Latest flagship |
| gpt-4o | 128K | Previous flagship |
| gpt-4o-mini | 128K | Fast, cheap |
| o3-mini | 128K | Reasoning model |

**Solutions:**
1. Check exact model name
2. Verify access permissions
3. Some models require API access approval

---

### Rate Limit (TPM/RPM)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "error": {                                                                │
│      "message": "Rate limit reached for gpt-4o",                             │
│      "type": "tokens",                                                       │
│      "code": "rate_limit_exceeded"                                           │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**OpenAI uses two rate limits:**
- **TPM**: Tokens per minute
- **RPM**: Requests per minute

**Solutions:**
1. Reduce request frequency
2. Use batch API for non-urgent requests
3. Request limit increase

---

## Google (Gemini) Errors

### Quota Exceeded

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "error": {                                                                │
│      "code": 429,                                                            │
│      "message": "Quota exceeded for quota metric",                           │
│      "status": "RESOURCE_EXHAUSTED"                                          │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Gemini Free Tier Limits:**

| Metric | Limit |
|--------|-------|
| Requests per minute | 60 |
| Requests per day | 1500 |
| Tokens per minute | 1M |

**Solutions:**
1. Wait for quota reset (per-minute or daily)
2. Upgrade to paid tier
3. Use Cloud AI Platform for higher limits

---

### Safety Filter Triggered

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "error": {                                                                │
│      "code": 400,                                                            │
│      "message": "Content was blocked due to safety settings",                │
│      "status": "INVALID_ARGUMENT"                                            │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**
1. Adjust safety settings (if using API directly):
```json
{
  "safetySettings": [
    {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"}
  ]
}
```
2. Rephrase prompt to avoid triggering filters
3. Use Gemini Advanced for less restrictive settings

---

## OpenRouter Errors

### Provider Error

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "error": {                                                                │
│      "code": 502,                                                            │
│      "message": "The upstream provider returned an error"                    │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**OpenRouter routes to multiple providers. When one fails:**

**Solutions:**
1. Retry (OpenRouter may route to different provider)
2. Specify fallback models:
```json
{
  "model": "anthropic/claude-opus-4-6",
  "fallbacks": ["openai/gpt-5.3-codex", "google/gemini-3-pro"]
}
```
3. Check individual provider status pages

---

### Credits Exhausted

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  {                                                                           │
│    "error": {                                                                │
│      "code": 402,                                                            │
│      "message": "Payment required"                                           │
│    }                                                                         │
│  }                                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**
1. Add credits at openrouter.ai/credits
2. Enable auto-recharge
3. Check usage dashboard

---

## Common Across Providers

### Network Timeout

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ETIMEDOUT                                                                   │
│  ECONNRESET                                                                  │
│  socket hang up                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**
1. Increase timeout:
```typescript
const response = await fetch(url, { timeout: 120000 });
```
2. Check network connectivity
3. Use streaming for long responses
4. Implement retry with backoff

---

### SSL Certificate Error

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  UNABLE_TO_VERIFY_LEAF_SIGNATURE                                             │
│  CERT_HAS_EXPIRED                                                            │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**
1. Update CA certificates:
```bash
# macOS
brew install ca-certificates

# Linux
sudo update-ca-certificates
```
2. Check system clock is correct
3. Don't disable SSL verification (security risk)

---

## Retry Strategy

Recommended exponential backoff:

```typescript
async function withRetry<T>(
  fn: () => Promise<T>,
  maxRetries = 5,
  baseDelay = 1000
): Promise<T> {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (!isRetryable(error) || attempt === maxRetries - 1) {
        throw error;
      }
      const delay = Math.min(baseDelay * Math.pow(2, attempt), 60000);
      const jitter = delay * 0.1 * Math.random();
      await new Promise(r => setTimeout(r, delay + jitter));
    }
  }
  throw new Error("Max retries exceeded");
}

function isRetryable(error: any): boolean {
  const retryableCodes = [429, 500, 502, 503, 529];
  return retryableCodes.includes(error.status);
}
```

---

## Environment Variables

```bash
# Anthropic
export ANTHROPIC_API_KEY="sk-ant-api03-..."

# OpenAI
export OPENAI_API_KEY="sk-proj-..."

# Google
export GOOGLE_API_KEY="AIza..."
# Or for Vertex AI:
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"

# OpenRouter
export OPENROUTER_API_KEY="sk-or-v1-..."
```

---

## Verification Commands

```bash
# Test Anthropic
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "content-type: application/json" \
  -H "anthropic-version: 2024-10-22" \
  -d '{"model":"claude-haiku-4-5","max_tokens":10,"messages":[{"role":"user","content":"Hi"}]}'

# Test OpenAI
curl https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-4o-mini","messages":[{"role":"user","content":"Hi"}],"max_tokens":10}'

# Test Google
curl "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$GOOGLE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Hi"}]}]}'
```

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [MCP Server Errors](./mcp-server-errors.md) | MCP protocol errors |
| [Cursor Errors](./cursor-errors.md) | Cursor IDE |
| [Oh My OpenCode Errors](./oh-my-opencode-errors.md) | Oh My OpenCode plugin |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.0 | 2026-02-07 | Initial provider error patterns |

---

*Last updated: 2026-02-07 | Sources: Anthropic, OpenAI, Google official docs*
*Maintainer: claude-error-prevention | License: MIT*
