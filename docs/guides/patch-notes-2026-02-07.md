# Claude Code Patch Notes (2026-02-07 기준)

> 공식 문서 기반 최신 업데이트 정리
> Source: code.claude.com, GitHub CHANGELOG.md

---

## 최신 버전: 2.1.34

### 핵심 변경사항

```
┌──────────────────────────────────────────────────────────────────────────────┐
│   2026년 2월 7일 기준 주요 업데이트                                           │
├──────────────────────────────────────────────────────────────────────────────┤
│   ✅ Claude Opus 4.6 출시 (2.1.32)                                           │
│   ✅ Agent Teams - 멀티 에이전트 협업 (실험적)                                 │
│   ✅ 자동 메모리 시스템 - 세션 간 기억 유지                                    │
│   ✅ Desktop App - 독립 실행형 앱 (Preview)                                   │
│   ✅ Claude Code on the Web - 브라우저에서 실행                                │
│   ✅ Task Management - 의존성 추적 지원                                        │
│   ✅ Keyboard Shortcuts - 커스텀 단축키                                        │
│   ✅ PR Review Status - 프롬프트에 PR 상태 표시                                │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 🆕 주요 신기능

### 1. Claude Opus 4.6 (v2.1.32)

Claude의 최신 모델이 Claude Code에서 사용 가능합니다.

```bash
# 모델 선택
claude --model opus
```

### 2. Agent Teams - 멀티 에이전트 협업 (실험적)

여러 Claude Code 인스턴스가 팀으로 협업하는 기능.

**활성화 방법:**
```json
// ~/.claude/settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

**사용 예시:**
```
CLI에서 Claude에게 말하기:
"Create an agent team with 3 teammates:
- One focused on security implications
- One checking performance impact  
- One validating test coverage"
```

| 구성요소 | 역할 |
|----------|------|
| Team Lead | 팀 생성, 조율, 태스크 할당 |
| Teammates | 독립적으로 태스크 수행 |
| Task List | 공유 작업 목록 |
| Mailbox | 에이전트 간 메시지 시스템 |

**Subagent vs Agent Teams:**

| 항목 | Subagents | Agent Teams |
|------|-----------|-------------|
| Context | 자체 컨텍스트, 결과만 반환 | 완전히 독립적 |
| Communication | 메인 에이전트에만 보고 | 팀원끼리 직접 메시지 |
| Token Cost | 낮음 (결과 요약) | 높음 (각자 독립 인스턴스) |
| Best For | 빠른 포커스 작업 | 복잡한 협업 |

### 3. 자동 메모리 시스템 (v2.1.32)

Claude가 작업하면서 자동으로 기억을 저장하고 다음 세션에서 참조합니다.

**메모리 유형:**

| 메모리 타입 | 위치 | 용도 | 공유 범위 |
|-------------|------|------|-----------|
| Managed Policy | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) | 조직 전체 지침 | 조직 전체 |
| Project Memory | `./CLAUDE.md` 또는 `./.claude/CLAUDE.md` | 팀 공유 프로젝트 지침 | 팀 (소스 컨트롤) |
| Project Rules | `./.claude/rules/*.md` | 모듈별 규칙 | 팀 (소스 컨트롤) |
| User Memory | `~/.claude/CLAUDE.md` | 개인 전체 프로젝트 설정 | 본인만 |
| Project Local | `./CLAUDE.local.md` | 개인 프로젝트별 설정 | 본인만 (현재 프로젝트) |

**경로별 조건부 규칙:**
```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules
- All API endpoints must include input validation
- Use the standard error response format
```

**Import 구문:**
```markdown
See @README for project overview and @package.json for available npm commands.

# Additional Instructions
- git workflow @docs/git-instructions.md
```

### 4. Desktop App (Preview)

독립 실행형 데스크톱 앱으로 Claude Code 사용.

**다운로드:**
- macOS: Universal build (Intel + Apple Silicon)
- Windows: x64, ARM64

**주요 탭:**
| 탭 | 기능 |
|----|------|
| Chat | 일반 대화 (claude.ai처럼) |
| Cowork | 백그라운드 자율 작업 |
| Code | 코드 직접 편집 (= CLI 기능) |

**Permission Modes:**
| 모드 | 설명 |
|------|------|
| Ask | 모든 편집/명령에 승인 필요 (초보자 권장) |
| Code | 파일 편집 자동, 터미널 명령만 승인 |
| Plan | 변경 전 상세 계획 먼저 승인 |

### 5. Claude Code on the Web (Research Preview)

브라우저에서 claude.ai/code로 접속하여 사용.

**장점:**
- 로컬 설치 없이 사용
- 여러 태스크 병렬 실행
- 로컬에 없는 레포에서도 작업 가능
- 노트북 닫아도 계속 실행

**터미널에서 웹으로 보내기:**
```bash
# & 접두사로 웹에서 실행
& Fix the authentication bug in src/auth/login.ts

# 또는 플래그 사용
claude --remote "Fix the bug"
```

**웹에서 터미널로 가져오기:**
```bash
# 대화형 선택
claude --teleport

# 또는 CLI에서 /teleport 명령
/teleport
```

### 6. Task Management 시스템 (v2.1.16)

의존성 추적이 포함된 새로운 태스크 관리.

```bash
# 태스크 목록 확인
/tasks

# 태스크 삭제 가능 (v2.1.20)
# TaskUpdate 도구로 삭제
```

### 7. Keyboard Shortcuts (v2.1.18)

커스텀 키보드 단축키 설정.

```bash
# 설정 시작
/keybindings
```

컨텍스트별 키바인딩, 코드 시퀀스 생성, 개인화 워크플로우 가능.

### 8. PR Review Status (v2.1.20)

프롬프트 푸터에 현재 브랜치의 PR 상태 표시:
- 승인됨 (approved)
- 변경 요청 (changes requested)
- 대기 중 (pending)
- 드래프트 (draft)

### 9. Session-PR 연결 (v2.1.27)

```bash
# 특정 PR과 연결된 세션 재개
claude --from-pr 123

# gh pr create로 생성 시 자동 연결
```

---

## 🔧 플랫폼 확장

### 지원 플랫폼 목록

| 플랫폼 | 설명 |
|--------|------|
| **Terminal (CLI)** | 핵심 Claude Code 경험 |
| **Desktop App** | 독립 실행형 앱, 세션 관리 UI |
| **Claude Code on the Web** | 브라우저에서 실행, 병렬 작업 |
| **VS Code** | 네이티브 확장, 인라인 diff, @멘션 |
| **JetBrains IDEs** | IntelliJ, PyCharm, WebStorm 등 |
| **GitHub Actions** | CI/CD에서 @claude 멘션으로 자동화 |
| **GitLab CI/CD** | MR 및 이슈 자동화 |
| **Slack** | 슬랙에서 Claude 멘션하여 코딩 태스크 |
| **Chrome** | 브라우저 연결하여 라이브 디버깅 |

---

## 📋 버전별 주요 변경사항

### v2.1.34
- Agent Teams 설정 변경 시 크래시 수정
- `autoAllowBashIfSandboxed` 활성화 시 샌드박스 우회 버그 수정

### v2.1.33
- tmux에서 Agent Teammate 세션 메시지 송수신 수정
- `TeammateIdle`, `TaskCompleted` 훅 이벤트 추가
- Agent `memory` frontmatter 필드 추가 (`user`, `project`, `local` 스코프)
- Extended thinking 중 메시지 제출 시 인터럽트 수정
- API 프록시 호환성 개선
- **VSCode**: 원격 세션 지원, Git 브랜치 및 메시지 수 표시

### v2.1.32
- **Claude Opus 4.6** 출시!
- **Agent Teams** 연구 프리뷰 추가
- **자동 메모리 기록/회상** 기능
- "Summarize from here" 부분 요약 기능
- `--add-dir`로 추가된 디렉터리의 스킬 자동 로드
- Skill 캐릭터 버짓이 컨텍스트 윈도우 2%로 스케일
- **VSCode**: 세션 forking 및 rewind 활성화

### v2.1.31
- 세션 종료 시 resume 힌트 표시
- 일본어 IME 전각 스페이스 입력 지원
- PDF 너무 큼 에러로 세션 잠김 수정
- `temperatureOverride` 스트리밍 API 경로에서 무시되던 문제 수정

### v2.1.30
- PDF `pages` 파라미터 추가 (예: `pages: "1-5"`)
- OAuth 클라이언트 사전 구성 지원 (`--client-id`, `--client-secret`)
- `/debug` 명령 추가
- 추가 git 플래그 지원 (`--topo-order`, `--cherry-pick` 등)
- Reduced motion mode 추가

### v2.1.27
- `--from-pr` 플래그로 특정 PR 세션 재개
- `gh pr create` 시 자동 PR 연결
- `/context` 컬러 출력 수정

### v2.1.20
- **PR Review Status** 프롬프트 푸터에 표시
- `--add-dir` 플래그의 CLAUDE.md 로드 지원
- 세션 compaction 수정
- 와이드 캐릭터 렌더링 수정

### v2.1.18
- **커스텀 키보드 단축키** 추가

### v2.1.16
- **새 태스크 관리 시스템** (의존성 추적)
- **VSCode**: 네이티브 플러그인 관리
- OOM 크래시 수정

### v2.1.15
- npm 설치 deprecated 알림 추가
- React Compiler로 UI 렌더링 성능 개선

---

## ⚠️ 설치 방법 변경 (중요!)

### npm 설치는 Deprecated

```bash
# ❌ 더 이상 권장하지 않음
npm install -g @anthropic-ai/claude-code

# ✅ 권장: Native Install
curl -fsSL https://claude.ai/install.sh | bash

# ✅ 또는 Homebrew (자동 업데이트 안 됨)
brew install --cask claude-code

# ✅ 또는 WinGet
winget install Anthropic.ClaudeCode
```

**주의**: Native install만 자동 업데이트됩니다. Homebrew/WinGet은 수동 업데이트 필요.

---

## 🔐 보안 및 권한

### 새로운 권한 관리

v2.1.20부터 `Bash(*)` 같은 권한 규칙이 `Bash`와 동일하게 처리됩니다.

### Config 백업 자동화

설정 백업이 타임스탬프로 저장되며 최근 5개 유지.

### Agent Teams 권한

Teammates는 Lead의 권한 설정을 상속받습니다. Lead가 `--dangerously-skip-permissions`로 실행하면 모든 Teammates도 동일.

---

## 📁 파일 구조 변경

### 새로운 Rules 디렉터리

```
your-project/
├── .claude/
│   ├── CLAUDE.md           # 메인 프로젝트 지침
│   └── rules/
│       ├── code-style.md   # 코드 스타일
│       ├── testing.md      # 테스팅 규칙
│       └── security.md     # 보안 요구사항
```

### Agent Teams 저장 위치

```
~/.claude/teams/{team-name}/config.json    # 팀 설정
~/.claude/tasks/{team-name}/               # 태스크 목록
```

---

## 💡 마이그레이션 가이드

### 기존 사용자

1. **npm 버전 제거**:
   ```bash
   npm uninstall -g @anthropic-ai/claude-code
   ```

2. **Native 설치**:
   ```bash
   curl -fsSL https://claude.ai/install.sh | bash
   ```

3. **CLAUDE.md 구조 업데이트** (선택):
   - `.claude/rules/` 디렉터리 생성
   - 주제별 규칙 파일 분리

4. **Agent Teams 시도** (선택):
   ```json
   // ~/.claude/settings.json
   {
     "env": {
       "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
     }
   }
   ```

---

## 🔗 공식 문서 링크

| 문서 | URL |
|------|-----|
| Overview | https://code.claude.com/docs/en/overview |
| Memory | https://code.claude.com/docs/en/memory |
| Desktop | https://code.claude.com/docs/en/desktop |
| Web | https://code.claude.com/docs/en/claude-code-on-the-web |
| Agent Teams | https://code.claude.com/docs/en/agent-teams |
| Settings | https://code.claude.com/docs/en/settings |
| Hooks | https://code.claude.com/docs/en/hooks |
| MCP | https://code.claude.com/docs/en/mcp |

---

*Last updated: 2026-02-07*
*Source: code.claude.com, GitHub anthropics/claude-code CHANGELOG.md*
