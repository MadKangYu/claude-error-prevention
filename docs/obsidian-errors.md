# Obsidian Error Patterns

## Overview

| Component | Location |
|-----------|----------|
| Vault | `~/Obsidian/Vault` (default) |
| QMD Index | `~/.cache/qmd/index.sqlite` |
| Config | `.obsidian/` (inside vault) |

## Installation

### QMD (Local Search)

```bash
# Homebrew (recommended)
brew install tobi/tap/qmd

# Go
go install github.com/tobi/qmd@latest
```

### QMD Setup

```bash
# Add vault collection
qmd collection add ~/Obsidian/Vault --name vault --mask "**/*.md"

# Build index
qmd update

# Add vector embeddings (for semantic search)
qmd embed
```

## Common Errors

### 1. Vault Not Found

**Error:**
```
Vault path does not exist
```

**Cause:** Vault moved or path changed

**Fix:**
1. Open Obsidian
2. Open another vault → Select correct path
3. Or check `~/Obsidian/Vault` exists

---

### 2. QMD Index Missing

**Error:**
```
No index found
```

**Cause:** QMD not set up for vault

**Fix:**
```bash
# Create index
qmd collection add ~/path/to/vault --name vault --mask "**/*.md"
qmd update && qmd embed
```

---

### 3. Sync Conflicts

**Error:**
```
*.sync-conflict-* files appear in vault
```

**Cause:** iCloud, Dropbox, or OneDrive sync conflicts

**Fix:**
1. Search for `sync-conflict` in Obsidian
2. Compare with original file
3. Keep correct version, delete conflict file
4. Consider using Obsidian Sync instead

---

### 4. Orphaned Notes

**Symptom:** Notes with no links (isolated in Graph View)

**Cause:** Notes not linked from anywhere

**Detection:**
- Open Graph View
- Look for isolated nodes
- Use Orphan Files plugin

**Fix:**
- Link from relevant notes using `[[note-name]]`
- Or create a MOC (Map of Content) note
- Or delete if no longer needed

---

### 5. Plugin Compatibility

**Error:**
```
Plugin failed to load
```

**Cause:** Plugin incompatible with Obsidian version

**Fix:**
1. Update Obsidian to latest
2. Check plugin GitHub for issues
3. Disable problematic plugin
4. Report issue to plugin author

---

### 6. Large Vault Performance

**Symptom:** Slow startup, laggy typing

**Cause:** Too many files, plugins, or large attachments

**Fix:**
1. Disable unused plugins
2. Move large attachments to separate folder
3. Consider using Obsidian Publish for static export
4. Enable "Excluded files" in settings

---

## Verification Commands

```bash
# Check vault exists
ls -la ~/Obsidian/Vault

# Check QMD index
qmd collection list

# Search test
qmd search "test query"

# Find sync conflicts
find ~/Obsidian/Vault -name "*sync-conflict*"

# Count notes
find ~/Obsidian/Vault -name "*.md" | wc -l
```

## Integration with AI Agents

### Claude Code + Obsidian

```bash
# Start QMD MCP server
qmd mcp

# Add to ~/.claude/claude_code_config.json
{
  "mcpServers": {
    "qmd": {
      "command": "qmd",
      "args": ["mcp"]
    }
  }
}
```

### Available QMD Commands

| Command | Description |
|---------|-------------|
| `qmd search` | BM25 keyword search |
| `qmd vsearch` | Vector semantic search |
| `qmd query` | Hybrid search + rerank |
| `qmd mcp` | Start MCP server |

## Best Practices

1. **Regular Backups:** Use git or periodic exports
2. **Consistent Linking:** Always link related notes
3. **Flat Structure:** Prefer links over deep folder hierarchies
4. **Daily Notes:** Use daily notes for quick capture
5. **Templates:** Create templates for recurring note types
