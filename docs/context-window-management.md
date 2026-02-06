# Context Window Management

> *"수많은 플래그 명령어를 활용하지 못해서 그렇지 그게 가장 정확하고 효율적인 방법입니다."*

---

## Philosophy

Context Window는 AI의 작업 메모리. 한계가 있다.

**핵심 원칙:**
1. **필요한 것만 로드** — 전체 vault가 아닌, 관련 문서만
2. **구조화된 기억** — MEMORY.md는 인덱스, 상세는 별도 파일
3. **도구 활용** — QMD로 semantic search, CLI로 직접 실행
4. **주기적 정리** — /compact로 요약

---

## 1. Token Economics

| Model | Input Context | Output Limit | Cost |
|-------|---------------|--------------|------|
| Claude Opus 4.5 | 1M tokens | 128K | $5/$25 per 1M |
| Claude Sonnet 4.5 | 200K tokens | 64K | $3/$15 per 1M |
| Claude Haiku 4.5 | 200K tokens | 32K | $0.25/$1.25 per 1M |

**Token Estimation:**
- English: ~4 chars = 1 token
- Korean: ~2 chars = 1 token (한글이 더 비쌈)
- Code: ~3 chars = 1 token

---

## 2. MEMORY.md Architecture

### The 200-Line Constraint

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ MEMORY.md = INDEX, NOT DATABASE                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ❌ Wrong: 모든 정보를 MEMORY.md에 넣기                                       │
│  ✅ Correct: MEMORY.md는 인덱스, 상세 정보는 별도 파일                         │
│                                                                              │
│  MEMORY.md (< 200 lines)                                                     │
│  ├── Quick Reference (핵심만)                                                 │
│  ├── Links to Detail Files                                                   │
│  └── Current Session Context                                                 │
│                                                                              │
│  Detail Files (unlimited)                                                    │
│  ├── openclaw.md                                                             │
│  ├── ai-tools.md                                                             │
│  └── error-prevention.md (373 lines - 줄이지 말 것!)                          │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### File Structure

```
~/.claude/projects/-Users-*/memory/
├── MEMORY.md           # Index only (< 200 lines)
├── openclaw.md         # OpenClaw details
├── ai-tools.md         # Claude Code, Crush, QMD
├── github-repos.md     # Repository management
├── error-prevention.md # Full guidelines (DO NOT REDUCE)
└── agentation/         # Subtopic files
    ├── api.md
    └── schema.md
```

---

## 3. On-Demand Loading with QMD

### Why QMD?

| Approach | Tokens | Cost |
|----------|--------|------|
| Load full vault | 500K+ | $2.50 |
| QMD search + load needed | 50K | $0.25 |

**10x savings** by loading only what's needed.

### Search Commands

```bash
qmd search "keyword"    # BM25 exact match
qmd vsearch "concept"   # Semantic similarity
qmd query "question"    # Hybrid + reranking
```

---

## 4. CLI Direct Usage

> "옵시디언도 클로드 코드에서 돌리는것보다 그냥 CLI에서 돌리는게 더 효율적입니다. **토큰과 컨텍스트 윈도우 관점에서**"

| Approach | Tokens |
|----------|--------|
| Agent (자연어) | 10,000+ |
| CLI (직접) | 100-500 |

```bash
# ❌ Inefficient
"마지막 커밋 보여줘"  # 5,000+ tokens

# ✅ Efficient
git log -1 --oneline   # 100 tokens
```

---

## 5. /compact Strategies

| Context Usage | Action |
|---------------|--------|
| 0-30% | 정상 작업 |
| 30-50% | 대규모 작업 전 compact 고려 |
| 50-70% | ⚠️ compact 권장 |
| 70%+ | 🔴 즉시 compact |

---

## 6. Feedback Loop

```
대화 중 발견
    │
    ├─▶ Level 1: MEMORY.md "Current Context" (즉시)
    ├─▶ Level 2: 토픽 파일로 이동 (세션 종료)
    ├─▶ Level 3: rules/ 승격 (패턴화)
    └─▶ Level 4: GitHub 업데이트 (공유)
```

### What to Save

| Save ✅ | Don't Save ❌ |
|---------|--------------|
| 실수에서 배운 교훈 | 일회성 디버깅 |
| 새 효율적 방법 | 임시 작업 |
| 반복 패턴 | 공식 문서에 있는 것 |

---

## 7. Best Practices Checklist

### Session Start
- [ ] MEMORY.md < 200 lines
- [ ] QMD index updated (`qmd update`)

### During Work
- [ ] CLI for simple tasks
- [ ] QMD search instead of full load
- [ ] /compact at 50%

### Session End
- [ ] Save learnings to topic files
- [ ] Update MEMORY.md index
- [ ] `qmd update && qmd embed`

---

## Related

- [CLAUDE.md Configuration](./claude-code-errors.md)
- [OpenClaw Errors](./openclaw-errors.md)
- [MCP Server Errors](./mcp-server-errors.md)

---

*Last updated: 2026-02-07*
