# Scope Guide: Personal vs Universal

---

## Universal Patterns (범용)

These patterns apply to ALL users.

### Claude Code
| ID | Issue |
|----|-------|
| `claude-duplicate-install` | npm + native conflict |
| `claude-npm-deprecated` | npm installation deprecated |
| `claude-settings-schema` | Invalid schema URL |
| `claude-invalid-json-*` | JSON syntax errors |
| `claude-deprecated-mcp-location` | ~/.mcp.json deprecated |

### System
| ID | Issue |
|----|-------|
| `env-missing-jq` | jq not installed |
| `git-user-not-set` | Git user not configured |
| `ssh-key-missing` | No SSH key |
| `beginner-sudo-npm` | npm with sudo |
| `npm-peer-dependency` | Peer dep conflicts |

### Server/Network
| ID | Issue |
|----|-------|
| `server-connection-refused` | ECONNREFUSED |
| `server-timeout` | ETIMEDOUT |
| `server-ssl-error` | SSL/TLS errors |
| `quota-rate-limit` | API rate limits |

---

## Personal Patterns (개인화)

These are specific to certain setups.

### OpenClaw (MadKangYu specific)
| ID | Issue |
|----|-------|
| `openclaw-gateway-down` | Port 18789 |
| `openclaw-env-exposed` | .env in openclaw dir |
| `openclaw-browserless-down` | Port 3000 |

### Terminal (macOS specific)
| ID | Issue |
|----|-------|
| `terminal-iterm2-shell-integration` | iTerm2 only |
| `terminal-ghostty-config` | Ghostty only |

### Obsidian/QMD (specific workflow)
| ID | Issue |
|----|-------|
| `obsidian-vault-not-found` | ~/Obsidian/Vault path |
| `obsidian-qmd-not-indexed` | QMD specific |

---

## How to Use

### For Personal Use
```bash
# Use all patterns
./error-engine.sh heal
```

### For Universal Distribution
```bash
# Filter universal only
./error-engine.sh scan | grep -E "claude|system|server|quota"
```

---

## Pattern Categories

| Category | Scope | Count |
|----------|-------|-------|
| `claude-code` | Universal | 8 |
| `system` | Universal | 12 |
| `server` | Universal | 8 |
| `quota` | Universal | 5 |
| `beginner-mistake` | Universal | 5 |
| `openclaw` | Personal | 3 |
| `obsidian` | Personal | 4 |
| `terminal` | Personal | 2 |
| `opencode` | Semi-Universal | 4 |
| `failure-case` | Reference | 5 |

**Universal: 38 patterns**
**Personal: 9 patterns**
**Reference: 9 patterns**
