# Contributing to Claude Error Prevention

Thank you for your interest in contributing! This guide will help you get started.

```
                    CONTRIBUTION FLOW
                    
    ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
    │  Fork   │ ──▶ │  Edit   │ ──▶ │  Test   │ ──▶ │   PR    │
    └─────────┘     └─────────┘     └─────────┘     └─────────┘
         │               │               │               │
         ▼               ▼               ▼               ▼
      GitHub         patterns/       ./heal         Review
      Fork           docs/           command        & Merge
```

---

## Quick Start

```bash
# 1. Fork and clone
git clone https://github.com/YOUR_USERNAME/claude-error-prevention.git
cd claude-error-prevention

# 2. Make changes
# Edit patterns/error-patterns.json or docs/*.md

# 3. Test locally
./src/error-engine.sh scan

# 4. Submit PR
git checkout -b feature/your-feature
git add -A && git commit -m "feat: add new error pattern"
git push origin feature/your-feature
```

---

## Types of Contributions

### 1. New Error Patterns

Add patterns to `patterns/error-patterns.json`:

```json
{
  "id": "tool-error-name",
  "tool": "claude-code|crush|openclaw|obsidian|oh-my-opencode",
  "category": "installation|config|runtime|network|quota",
  "keywords": ["error", "message", "keywords"],
  "detect": {
    "command": "shell command to detect",
    "condition": "gt|lt|eq|contains",
    "value": 1
  },
  "message": "Human-readable error description",
  "severity": "error|warning|info",
  "fix": {
    "command": "auto-fix command (optional)",
    "description": "How to fix manually"
  }
}
```

**Requirements:**
- Unique `id` with tool prefix (e.g., `claude-mcp-timeout`)
- At least 3 keywords for searchability
- Reproducible `detect` command
- Clear `message` and `fix.description`

### 2. Documentation

Add or improve docs in `docs/`:

| File | Purpose |
|------|---------|
| `*-errors.md` | Tool-specific error guides |
| `glossary.md` | Korean → English terms |
| `error-examples.md` | Real error message samples |

**Documentation Standards:**
- Use ASCII diagrams for visual explanations
- Include actual error messages in code blocks
- Link to official documentation sources
- Add verification commands

### 3. Auto-Fix Scripts

Add fix commands to patterns:

```json
{
  "fix": {
    "command": "npm uninstall -g @anthropic-ai/claude-code",
    "description": "Remove deprecated npm installation"
  }
}
```

**Requirements:**
- Command must be idempotent (safe to run multiple times)
- Must not require sudo without explicit warning
- Include rollback instructions if destructive

---

## Pattern Guidelines

### ID Naming Convention

```
{tool}-{category}-{specific-error}

Examples:
  claude-install-duplicate
  crush-config-invalid-json
  openclaw-auth-token-expired
  obsidian-sync-conflict
```

### Severity Levels

| Level | When to Use |
|-------|-------------|
| `error` | Blocks functionality, needs immediate fix |
| `warning` | Degraded experience, should fix soon |
| `info` | Informational, optional improvement |

### Detection Commands

```bash
# Good: Specific, fast, returns clear result
which -a claude 2>/dev/null | wc -l

# Bad: Slow, unclear output
find / -name "claude" 2>/dev/null
```

---

## Testing Your Changes

### 1. Validate JSON

```bash
jq . patterns/error-patterns.json > /dev/null
# No output = valid JSON
```

### 2. Run Scan

```bash
./src/error-engine.sh scan
```

### 3. Test Specific Pattern

```bash
./src/error-engine.sh search "your-pattern-id"
```

### 4. Run Full Heal

```bash
./src/error-engine.sh heal
```

---

## Commit Message Format

```
type: short description

Types:
  feat     - New feature or pattern
  fix      - Bug fix
  docs     - Documentation only
  refactor - Code restructuring
  test     - Testing changes
  chore    - Maintenance tasks
```

**Examples:**
```
feat: add claude-mcp-server-crash pattern
fix: correct detection command for crush config
docs: update oh-my-opencode troubleshooting guide
```

---

## Pull Request Process

1. **Title**: Use commit message format
2. **Description**: Explain what and why
3. **Testing**: Describe how you tested
4. **Checklist**:
   - [ ] JSON is valid (`jq .` passes)
   - [ ] `./src/error-engine.sh scan` runs without errors
   - [ ] Documentation updated if needed
   - [ ] No secrets or personal paths in code

---

## Code of Conduct

- Be respectful and constructive
- Focus on the technical merits
- Help newcomers learn
- Give credit where due

---

## Questions?

- Open an [issue](https://github.com/MadKangYu/claude-error-prevention/issues)
- Check existing [discussions](https://github.com/MadKangYu/claude-error-prevention/discussions)

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

*Thank you for helping make AI coding agents more reliable!*
