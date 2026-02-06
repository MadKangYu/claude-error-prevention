# Claude Code Memory Management - Official Documentation Verification

> Step by step 검증 과정 기록 (2026-02-07)

---

## Step 1: 공식 문서 위치 확인

### 검증 명령어

```bash
curl -s "https://code.claude.com/docs/en/memory"
```

### 발견한 공식 문서 URL

```
https://code.claude.com/docs/en/memory
```

---

## Step 2: 공식 메모리 타입 (원문 그대로)

| Memory Type | Location | Purpose | Use Case Examples | Shared With |
|-------------|----------|---------|-------------------|-------------|
| **Managed policy** | macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`<br/>Linux: `/etc/claude-code/CLAUDE.md`<br/>Windows: `C:\Program Files\ClaudeCode\CLAUDE.md` | Organization-wide instructions managed by IT/DevOps | Company coding standards, security policies, compliance requirements | All users in organization |
| **Project memory** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team-shared instructions for the project | Project architecture, coding standards, common workflows | Team members via source control |
| **Project rules** | `./.claude/rules/*.md` | Modular, topic-specific project instructions | Language-specific guidelines, testing conventions, API standards | Team members via source control |
| **User memory** | `~/.claude/CLAUDE.md` | Personal preferences for all projects | Code styling preferences, personal tooling shortcuts | Just you (all projects) |
| **Project memory (local)** | `./CLAUDE.local.md` | Personal project-specific preferences | Your sandbox URLs, preferred test data | Just you (current project) |

---

## Step 3: 이전에 틀렸던 것 vs 공식 문서

### 오류 #1: 메모리 파일 경로

| 틀렸던 것 | 공식 문서 |
|-----------|-----------|
| `~/.claude/memory/MEMORY.md` | `~/.claude/CLAUDE.md` |
| `~/.claude/projects/.../memory/` | 공식 경로 아님 |

**발견 경위:**
```bash
# 우리가 사용하던 경로
ls ~/.claude/projects/-Users-*/memory/

# 공식 경로
ls ~/.claude/CLAUDE.md
```

### 오류 #2: rules 디렉토리 위치

| 틀렸던 것 | 공식 문서 |
|-----------|-----------|
| `~/.claude/rules/` (user level만 언급) | `./.claude/rules/` (project level) + `~/.claude/rules/` (user level) |

**공식 문서 원문:**
```
.claude/rules/
├── frontend/
│   ├── react.md
│   └── styles.md
├── backend/
│   ├── api.md
│   └── database.md
└── general.md
```

### 오류 #3: CLAUDE.local.md 존재 몰랐음

| 틀렸던 것 | 공식 문서 |
|-----------|-----------|
| 언급 없음 | `./CLAUDE.local.md` - 개인 프로젝트 설정용 |

**공식 문서 원문:**
> CLAUDE.local.md files are automatically added to .gitignore, making them ideal for private project-specific preferences that shouldn't be checked into version control.

---

## Step 4: 공식 기능 - Import 문법

### 공식 문서 원문

```markdown
See @README for project overview and @package.json for available npm commands.

# Additional Instructions
- git workflow @docs/git-instructions.md
```

### 규칙

1. `@path/to/file` 문법으로 다른 파일 import 가능
2. 상대 경로: import 하는 파일 기준
3. 절대 경로: 지원됨
4. 홈 디렉토리: `@~/.claude/my-project-instructions.md`
5. 최대 깊이: 5단계
6. 코드 블록 내 `@`는 무시됨

### 첫 사용 시 승인 필요

**공식 문서 원문:**
> The first time Claude Code encounters external imports in a project, it shows an approval dialog listing the specific files. Approve to load them; decline to skip them. This is a one-time decision per project.

---

## Step 5: 공식 기능 - Path-specific Rules

### 공식 문서 원문

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules

- All API endpoints must include input validation
- Use the standard error response format
- Include OpenAPI documentation comments
```

### Glob 패턴 지원

| Pattern | Matches |
|---------|---------|
| `**/*.ts` | All TypeScript files in any directory |
| `src/**/*` | All files under `src/` directory |
| `*.md` | Markdown files in the project root |
| `src/components/*.tsx` | React components in a specific directory |

### Brace Expansion

```markdown
---
paths:
  - "src/**/*.{ts,tsx}"
  - "{src,lib}/**/*.ts"
---
```

---

## Step 6: 메모리 로딩 순서 (공식)

### 공식 문서 원문

> Claude Code reads memories recursively: starting in the cwd, Claude Code recurses up to (but not including) the root directory / and reads any CLAUDE.md or CLAUDE.local.md files it finds.

### 로딩 순서

```
1. Managed policy (조직 레벨)
   └── /Library/Application Support/ClaudeCode/CLAUDE.md

2. User memory (사용자 레벨)
   ├── ~/.claude/CLAUDE.md
   └── ~/.claude/rules/*.md

3. Project memory (프로젝트 레벨 - 상위부터)
   ├── /path/to/project/CLAUDE.md
   ├── /path/to/project/.claude/CLAUDE.md
   ├── /path/to/project/.claude/rules/*.md
   └── /path/to/project/CLAUDE.local.md

4. Nested directories (하위 디렉토리)
   └── 해당 파일 작업 시에만 로드
```

**우선순위:** 상위 레벨이 먼저 로드되고, 하위 레벨이 override

---

## Step 7: /memory 명령어

### 공식 문서 원문

> Use the `/memory` command during a session to open any memory file in your system editor for more extensive additions or organization.

### 사용법

```bash
# Claude Code 세션 내에서
/memory
```

- 시스템 에디터에서 메모리 파일 열림
- 로드된 모든 메모리 파일 확인 가능

---

## Step 8: /init 명령어

### 공식 문서 원문

> Bootstrap a CLAUDE.md for your codebase with the following command:
> ```
> > /init
> ```

### 자동 생성되는 내용

- 프로젝트 개요
- 빌드/테스트 명령어
- 코드 스타일 가이드라인
- 아키텍처 패턴

---

## Step 9: 추가 디렉토리 메모리 로딩

### 공식 문서 원문

```bash
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ../shared-config
```

### 설명

- `--add-dir` 플래그로 추가 디렉토리 접근
- 기본값: 추가 디렉토리의 CLAUDE.md 로드 안 함
- `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`로 활성화

---

## Step 10: Symlink 지원

### 공식 문서 원문

```bash
# Symlink a shared rules directory
ln -s ~/shared-claude-rules .claude/rules/shared

# Symlink individual rule files
ln -s ~/company-standards/security.md .claude/rules/security.md
```

### 규칙

- Symlink 지원됨
- 여러 프로젝트에서 공유 가능
- Circular symlink 자동 감지

---

## Step 11: Best Practices (공식)

### 공식 문서 원문

1. **Be specific**: "Use 2-space indentation" is better than "Format code properly"
2. **Use structure to organize**: Format each individual memory as a bullet point and group related memories under descriptive markdown headings
3. **Review periodically**: Update memories as your project evolves

### rules/ 디렉토리 Best Practices

1. **Keep rules focused**: 각 파일은 하나의 주제만
2. **Use descriptive filenames**: 파일명으로 내용 파악 가능하게
3. **Use conditional rules sparingly**: paths는 정말 필요할 때만
4. **Organize with subdirectories**: 관련 규칙 그룹화

---

## Step 12: 검증 완료 체크리스트

| 항목 | 공식 문서 확인 | 상태 |
|------|---------------|------|
| 메모리 파일 경로 | ✅ | 수정됨 |
| CLAUDE.md 위치 | ✅ | 수정됨 |
| CLAUDE.local.md | ✅ | 새로 배움 |
| rules/ 디렉토리 | ✅ | 수정됨 |
| Import 문법 (@) | ✅ | 새로 배움 |
| Path-specific rules | ✅ | 새로 배움 |
| Glob 패턴 | ✅ | 새로 배움 |
| /memory 명령어 | ✅ | 확인됨 |
| /init 명령어 | ✅ | 확인됨 |
| 로딩 순서 | ✅ | 수정됨 |
| Symlink 지원 | ✅ | 새로 배움 |

---

## 수정된 우리 문서 vs 이전 문서

### 이전 (틀림)

```
~/.claude/
├── projects/
│   └── -Users-*/
│       └── memory/
│           ├── MEMORY.md       # 잘못된 파일명
│           └── openclaw.md
└── rules/                       # 위치만 맞고 용도 설명 부족
```

### 수정 후 (공식 기준)

```
~/.claude/
├── CLAUDE.md                    # User memory (모든 프로젝트)
└── rules/                       # User-level rules
    ├── preferences.md
    └── workflows.md

./project/
├── CLAUDE.md                    # Project memory (팀 공유)
├── CLAUDE.local.md              # Project memory (개인, .gitignore)
└── .claude/
    ├── CLAUDE.md                # Alternative location
    └── rules/                   # Project rules
        ├── code-style.md
        ├── testing.md
        └── frontend/
            └── react.md
```

---

## 검증 방법 재현

```bash
# 1. 공식 문서 URL
curl -s "https://code.claude.com/docs/en/memory" > /tmp/official-memory.md

# 2. 핵심 섹션 추출
grep -A50 "## Determine memory type" /tmp/official-memory.md

# 3. 우리 문서와 비교
diff <(grep "CLAUDE.md" /tmp/official-memory.md | head -10) \
     <(grep "CLAUDE.md" our-docs/memory.md | head -10)

# 4. 실제 테스트
ls -la ~/.claude/CLAUDE.md
ls -la ~/.claude/rules/
ls -la ./.claude/rules/
```

---

## 출처

- **공식 문서**: https://code.claude.com/docs/en/memory
- **GitHub**: https://github.com/anthropics/claude-code
- **검증일**: 2026-02-07
- **검증 방법**: curl + WebFetch (비교 검증)

---

## 다음 검증 필요 항목

1. [ ] MCP 설정 공식 문서 검증
2. [ ] Settings.json 스키마 검증
3. [ ] Hook 시스템 공식 문서 검증
4. [ ] Plugin 시스템 공식 문서 검증
