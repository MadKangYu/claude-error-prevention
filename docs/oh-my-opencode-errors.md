# Oh My OpenCode Error Patterns

**Repository:** https://github.com/code-yeongyu/oh-my-opencode (branch: dev)  
**Version:** 3.2.4+

> **WARNING:** ohmyopencode.com is NOT affiliated with the official project.
> Only download from GitHub releases.

---

## Installation

### Quick Install
```bash
bunx oh-my-opencode install
```

### Non-Interactive (for CI/agents)
```bash
bunx oh-my-opencode install --no-tui \
  --claude=max20 \
  --openai=yes \
  --gemini=no \
  --copilot=no
```

### Verify Installation
```bash
opencode --version  # Should be 1.0.150+
cat ~/.config/opencode/opencode.json | jq '.plugin'  # Should include "oh-my-opencode"
```

### Uninstall
```bash
jq '.plugin = [.plugin[] | select(. != "oh-my-opencode")]' \
    ~/.config/opencode/opencode.json > /tmp/oc.json && \
    mv /tmp/oc.json ~/.config/opencode/opencode.json
```

---

## Configuration

### File Locations (Priority Order)

| Priority | Path |
|----------|------|
| 1 | `.opencode/oh-my-opencode.json` (project) |
| 2 | `~/.config/opencode/oh-my-opencode.json` (user) |

**JSONC supported** (comments + trailing commas)

### Schema Autocomplete
```json
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json"
}
```

### Example Config
```jsonc
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  
  "agents": {
    "oracle": { "model": "openai/gpt-5.2" },
    "explore": { "model": "anthropic/claude-haiku-4-5" }
  },
  
  "categories": {
    "quick": { "model": "anthropic/claude-haiku-4-5" },
    "visual-engineering": { "model": "google/gemini-3-pro" }
  },
  
  "background_task": {
    "defaultConcurrency": 5
  }
}
```

---

## Built-in Agents

| Agent | Purpose | Default Model |
|-------|---------|---------------|
| Sisyphus | Main orchestrator | claude-opus-4-6 |
| oracle | Architecture, debugging | gpt-5.2 |
| librarian | Docs, OSS examples | glm-4.7 |
| explore | Fast codebase search | claude-haiku-4-5 |
| Prometheus | Strategic planner | claude-opus-4-6 |
| Metis | Pre-planning analysis | claude-opus-4-6 |
| Momus | Plan reviewer | gpt-5.2 |

---

## Common Errors

### 1. Ollama JSON Parse Error

**Error:**
```
Error: JSON Parse error: Unexpected EOF
```

**Cause:** Ollama returns NDJSON with streaming enabled

**Fix:**
```json
{
  "agents": {
    "explore": {
      "model": "ollama/qwen3-coder",
      "stream": false
    }
  }
}
```

---

### 2. OpenCode Version Too Old

**Error:**
```
Config parsing failed
```

**Cause:** OpenCode < 1.0.150 has config bugs

**Fix:**
```bash
opencode --version  # Check version
# Upgrade following OpenCode docs
```

---

### 3. Plugin Not Loaded

**Symptom:** No oh-my-opencode features available

**Check:**
```bash
cat ~/.config/opencode/opencode.json | jq '.plugin'
```

**Fix:**
```bash
bunx oh-my-opencode install
```

---

### 4. AGENTS.md Missing

**Error:**
```
[WARN] No AGENTS.md found
```

**Fix:** Run `/init-deep` in OpenCode

---

### 5. Context Window Limit

**Error:**
```
Context window exceeded
```

**Fix:** Enable auto-resume:
```json
{
  "experimental": {
    "auto_resume": true,
    "aggressive_truncation": true
  }
}
```

---

### 6. Agent-Browser Installation Failure

**Error:**
```
No binary found for darwin-arm64
```

**Fix:**
```bash
npx playwright install chromium
```

---

## Skills

### Locations
```
.opencode/skills/*/SKILL.md      # Project
~/.config/opencode/skills/*/SKILL.md  # User
.claude/skills/*/SKILL.md        # Claude compat
```

### Built-in Skills

| Skill | Trigger |
|-------|---------|
| playwright | Browser automation |
| frontend-ui-ux | UI/UX tasks |
| git-master | Git operations |

---

## Magic Keywords

| Keyword | Effect |
|---------|--------|
| `ultrawork` / `ulw` | Maximum performance mode |
| `search` / `find` | Parallel exploration |
| `analyze` | Deep analysis |
| `ultrathink` | Extended thinking |

---

## Slash Commands

| Command | Description |
|---------|-------------|
| `/init-deep` | Create AGENTS.md |
| `/ralph-loop` | Self-referential dev loop |
| `/ulw-loop` | Ultrawork loop |
| `/refactor` | Intelligent refactoring |
| `/start-work` | Execute plan |

---

## Verification

```bash
# Version
opencode --version

# Plugin status
cat ~/.config/opencode/opencode.json | jq '.plugin'

# Config validation
bunx oh-my-opencode doctor --verbose

# AGENTS.md check
ls -la ./AGENTS.md
```
