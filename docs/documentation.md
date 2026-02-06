# Documentation Rules

## Core Principle

**Verbatim Copy**: Official documentation must be copied exactly as written.

## Forbidden

- Summarizing ("keeps output minimal" → "Minimal")
- Translating (unless explicitly requested)
- Paraphrasing ("Get" → "Retrieve")
- Adding content not in original
- Removing content from original

## Required

### Before Documentation Work
1. Find official source location
   ```bash
   gh api repos/{owner}/{repo}/contents --jq '.[].name'
   ```

2. Get raw content
   ```bash
   curl -s https://raw.githubusercontent.com/{owner}/{repo}/main/{path}
   ```

3. Confirm: translation/summary requested? (Default: NO)

### After Documentation Work
1. Compare with source
   ```bash
   diff local.md <(curl -s https://raw.githubusercontent.com/...)
   ```

2. Document verification method used

3. Provide source URL for user verification

4. Do NOT claim "100% match"

## GitHub Raw Access

```bash
# Preferred method (no AI)
curl -s https://raw.githubusercontent.com/{owner}/{repo}/main/{path}

# Structure discovery
gh api repos/{owner}/{repo}/contents/{path} --jq '.[].name'
```

## When Source is JSX/TSX

If documentation is embedded in React components (not plain markdown):

1. Fetch the raw TSX file
2. Extract text content manually
3. Note: content is in JSX, exact copy may need formatting adjustment
4. Always reference the source file path

Example:
```bash
# Agentation docs are in TSX
curl -s https://raw.githubusercontent.com/benjitaylor/agentation/main/package/example/src/app/schema/page.tsx
```
