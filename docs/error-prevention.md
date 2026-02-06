# Error Prevention Rules

## Forbidden Actions

- Never claim "100% complete" or "perfect"
- Never summarize official documentation
- Never translate without explicit request
- Never assume config paths - verify first
- Never use WebFetch for verification (AI bias)

## Required Actions

### Before Any Task
1. Check existing state: `which -a`, `ls -la`, `cat`
2. Find official source (GitHub raw preferred)
3. Confirm requirements with user if unclear

### After Any Task
1. Show actual command output
2. Provide verification method
3. State limitations honestly

## Verification Hierarchy

| Method | Trust Level | Use For |
|--------|-------------|---------|
| GitHub raw | 100% | Source code, docs |
| CLI output | 100% | Version, status |
| curl + html2text | 95% | HTML without AI |
| diff | 95% | File comparison |
| WebFetch | 70% | Exploration only |
| Memory | 0% | Never rely |

## Common Mistakes to Avoid

| Mistake | Correct Approach |
|---------|------------------|
| "Minimal output" | "No React data (keeps output minimal)" |
| "Retrieve annotation" | "Get annotation" |
| `~/.mcp.json` | `~/.claude/claude_code_config.json` |
| npm + native both | native only |
