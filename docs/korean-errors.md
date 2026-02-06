# Korean User Error Patterns

> AI 에이전트가 한국어 사용자와 작업할 때 발생하는 에러 패턴

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██╗  ██╗ ██████╗ ██████╗ ███████╗ █████╗ ███╗   ██╗                        ║
║   ██║ ██╔╝██╔═══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║                        ║
║   █████╔╝ ██║   ██║██████╔╝█████╗  ███████║██╔██╗ ██║                        ║
║   ██╔═██╗ ██║   ██║██╔══██╗██╔══╝  ██╔══██║██║╚██╗██║                        ║
║   ██║  ██╗╚██████╔╝██║  ██║███████╗██║  ██║██║ ╚████║                        ║
║   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝                        ║
║                                                                              ║
║   Error Prevention System v3.1 | Patterns: 4 | Language: Korean             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

English-based documentation with Korean error examples in comments.

---

## Ambiguous Commands

```bash
# User: "정리해줘" (organize/clean)
# ERROR: AI deletes files instead of organizing
# FIX: Always ask - "Delete or reorganize?"

# User: "지워줘" (delete/clear)
# ERROR: AI deletes file instead of clearing output
# FIX: Confirm target - "Delete file or clear screen?"

# User: "바꿔줘" (change/replace)
# ERROR: AI replaces entire file instead of modifying
# FIX: Ask scope - "Modify specific part or replace all?"
```

---

## Implicit Expectations

```bash
# User: "설치해" (install)
# ERROR: AI only runs install command
# EXPECTED: Install + verify + report result

# User: "고쳐" (fix)
# ERROR: AI fixes one issue only
# EXPECTED: Fix + test + verify + report

# User: "확인해" (check)
# ERROR: AI just reads file
# EXPECTED: Check + fix if wrong + report
```

---

## Frustration Indicators

```bash
# User: "안돼" / "안됨" (doesn't work)
# MEANING: Not a status update, wants it FIXED

# User: "이상해" (strange)
# MEANING: Something is wrong, investigate and fix

# User: "왜이래" (why is it like this)
# MEANING: Unacceptable state, fix immediately

# User: "또?" (again?)
# MEANING: Recurring issue, needs permanent fix
```

---

## Dangerous Phrases

```bash
# User: "다 지워" (delete all)
# DANGER: Mass deletion
# ACTION: STOP, confirm scope, list affected items

# User: "싹 밀어" (wipe clean)
# DANGER: Irreversible destruction
# ACTION: STOP, require explicit confirmation

# User: "초기화해" (reset/initialize)
# DANGER: Data loss
# ACTION: STOP, ask about backup first

# User: "리셋" (reset)
# DANGER: Factory reset implied
# ACTION: STOP, clarify what to reset
```

---

## Scope Confusion

```bash
# User: "전부" (all)
# LITERAL: 100% everything
# ACTUAL: All relevant items only

# User: "다" (all)
# LITERAL: Everything
# ACTUAL: Common/important ones

# User: "이것만" (just this)
# LITERAL: Exactly this one
# ACTUAL: This + obviously related items

# User: "좀" (a little/some)
# LITERAL: Minimal
# ACTUAL: Appropriate amount
```

---

## Context-Dependent Verbs

```bash
# "돌려" (run/revert)
# Code context: Execute/Run
# Git context: Revert to previous

# "올려" (upload/push)
# File context: Upload
# Git context: git push

# "내려" (download/pull)
# File context: Download
# Git context: git pull

# "합쳐" (merge)
# File context: Combine files
# Git context: git merge
```

---

## Abbreviations (Korean Internet Slang)

```bash
# "ㄱㄱ" = Go (proceed)
# "ㅇㅇ" = Yes/OK
# "ㄴㄴ" = No
# "ㅇㅋ" = OK
# "ㄱㅅ" = Thanks (감사)
# "ㅠㅠ" = Frustrated/sad (needs help)
```

---

## OpenClaw / Telegram Bot Specific

```bash
# User: "봇이 안돼" (bot doesn't work)
# CHECK: OpenClaw gateway status (port 18789)
# CHECK: Telegram bot token validity
# CHECK: Webhook configuration

# User: "응답이 없어" (no response)
# CHECK: curl http://localhost:18789/health
# CHECK: Agent configuration in openclaw.json
# CHECK: Rate limits / quota

# User: "메시지가 안가" (message not sending)
# CHECK: Telegram API connectivity
# CHECK: Bot permissions in group
# CHECK: allowlist/policy settings
```

---

## Prevention Rules

### Rule 1: Deletion
```bash
# Before ANY delete operation:
# 1. Echo what will be deleted
# 2. Ask for explicit "네" or "삭제해"
# 3. Create backup if possible
```

### Rule 2: Scope
```bash
# Before bulk operations:
# 1. List affected files/items
# 2. Show count
# 3. Get confirmation
```

### Rule 3: Implicit Commands
```bash
# When user says vague command:
# 1. Identify possible interpretations
# 2. Ask which one intended
# 3. Execute only after clarification
```

---

## Quick Reference

| Korean | Risk Level | Action |
|--------|------------|--------|
| 지워 | HIGH | Confirm first |
| 정리 | MEDIUM | Ask: delete or organize? |
| 바꿔 | MEDIUM | Ask: modify or replace? |
| 다 | MEDIUM | Clarify scope |
| 초기화 | HIGH | Backup warning |
| 밀어 | HIGH | Full stop, confirm |

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [Claude Code Errors](./claude-code-errors.md) | Claude Code CLI errors |
| [Oh My OpenCode Errors](./oh-my-opencode-errors.md) | Oh My OpenCode plugin |
| [OpenClaw Errors](./openclaw-errors.md) | Telegram bot integration |
| [Common Errors](./common-errors.md) | Lessons learned patterns |
| [Glossary](./glossary.md) | Korean → English terms |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.1 | 2026-02-07 | Added cross-references, header |
| 1.0 | 2026-02-06 | Initial patterns |

---

*Last updated: 2026-02-07 | Maintainer: claude-error-prevention*
