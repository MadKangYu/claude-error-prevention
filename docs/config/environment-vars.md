# Environment Variables Reference

> All environment variables for Claude Code, Crush, OpenCode, and OpenClaw.
> Source: code.claude.com/docs/en/settings, charmbracelet/crush

---

## Claude Code

### Authentication

| Variable | Description | Example |
|----------|-------------|---------|
| `ANTHROPIC_API_KEY` | Anthropic API key (Console billing) | `sk-ant-...` |
| `CLAUDE_CODE_USE_BEDROCK` | Use Amazon Bedrock | `1` |
| `CLAUDE_CODE_USE_VERTEX` | Use Google Vertex AI | `1` |

### AWS Bedrock

| Variable | Description |
|----------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `AWS_REGION` | AWS region |
| `AWS_PROFILE` | AWS profile name |
| `AWS_BEARER_TOKEN_BEDROCK` | Bearer token |

### Google Vertex AI

| Variable | Description |
|----------|-------------|
| `VERTEXAI_PROJECT` | GCP project ID |
| `VERTEXAI_LOCATION` | GCP region |
| `GOOGLE_APPLICATION_CREDENTIALS` | Service account path |

### Behavior

| Variable | Description | Default |
|----------|-------------|---------|
| `DISABLE_AUTOUPDATER` | Disable auto-updates | `0` |
| `CLAUDE_CODE_ENABLE_TELEMETRY` | Enable telemetry | `0` |
| `CLAUDE_CODE_GIT_BASH_PATH` | Git Bash path (Windows) | - |
| `USE_BUILTIN_RIPGREP` | Use builtin ripgrep | `1` |

### Debug

| Variable | Description |
|----------|-------------|
| `CLAUDE_CODE_DEBUG` | Enable debug mode |
| `CLAUDE_CODE_DEBUG_API` | Debug API calls |

---

## Crush (Charmbracelet)

### Provider Keys

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_KEY` | Anthropic API key |
| `OPENAI_API_KEY` | OpenAI API key |
| `GEMINI_API_KEY` | Google Gemini key |
| `GROQ_API_KEY` | Groq API key |
| `OPENROUTER_API_KEY` | OpenRouter API key |
| `DEEPSEEK_API_KEY` | DeepSeek API key |

### Configuration

| Variable | Description |
|----------|-------------|
| `CRUSH_GLOBAL_CONFIG` | Custom config path |
| `CRUSH_GLOBAL_DATA` | Custom data path |
| `CRUSH_DISABLE_METRICS` | Disable telemetry |
| `CRUSH_DISABLE_PROVIDER_AUTO_UPDATE` | Disable provider updates |
| `DO_NOT_TRACK` | Disable all tracking |

---

## OpenCode (anomalyco)

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_KEY` | Anthropic API key |
| `OPENAI_API_KEY` | OpenAI API key |
| `OPENCODE_CONFIG` | Custom config path |

---

## OpenClaw

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_KEY` | Anthropic API key |
| `OPENAI_API_KEY` | OpenAI API key |
| `OPENCLAW_GATEWAY_PORT` | Gateway port (default: 18789) |
| `OPENCLAW_LOG_LEVEL` | Log level (debug/info/warn/error) |

---

## QMD

| Variable | Description |
|----------|-------------|
| `QMD_MODEL` | Default model for embeddings |
| `QMD_CONFIG` | Custom config path |

---

## Verification

```bash
# Check all relevant env vars
env | grep -E "(ANTHROPIC|OPENAI|CLAUDE|CRUSH|OPENCLAW|QMD|AWS|VERTEX)" | sort

# Verify API keys are set (masked)
echo "ANTHROPIC: ${ANTHROPIC_API_KEY:+SET}"
echo "OPENAI: ${OPENAI_API_KEY:+SET}"
```

---

## Security Notes

1. **Never commit API keys to git**
2. Use `.env` files with `.gitignore`
3. Prefer environment variables over config files for secrets
4. Rotate keys if accidentally exposed

---

*Last updated: 2026-02-07*
*Source: code.claude.com/docs/en/settings, charmbracelet/crush*
