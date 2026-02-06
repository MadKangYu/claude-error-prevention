# Claude Code로 떠나는 여행

> 어느 개발자의 하루

---

## 프롤로그: 새벽 3시의 절망

김개발은 모니터를 노려보았다.

```
TypeError: Cannot read properties of undefined (reading 'map')
```

"또야..."

스택오버플로우 탭 17개. 깃허브 이슈 탭 8개. 
ChatGPT한테 복붙하다가 컨텍스트 날아간 것만 세 번.

그때, 옆자리 선배가 말했다.

**"Claude Code 써봐. 터미널에서 바로 코드 고쳐줌."**

---

## 1장: 설치 — 단 한 줄의 마법

김개발은 터미널을 열었다. 검은 화면이 깜빡인다.

**Mac/Linux라면:**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows라면:**

```powershell
irm https://claude.ai/install.ps1 | iex
```

Enter를 누르자, 글자들이 스르륵 흘러내렸다.

```
Installing Claude Code...
████████████████████████ 100%
✓ Claude Code installed successfully!
```

끝이다. 정말로.

---

## 2장: 첫 만남

```bash
claude
```

화면이 바뀌었다.

```
╭─────────────────────────────────────╮
│  Welcome to Claude Code             │
│  Your AI pair programmer            │
╰─────────────────────────────────────╯

>
```

김개발은 떨리는 손으로 타이핑했다.

```
> 이 에러 좀 봐줘: Cannot read properties of undefined
```

Claude가 답했다.

```
코드를 보여주세요. 
아, 잠깐... 현재 디렉토리에 있는 파일들을 확인해볼게요.

📂 src/components/UserList.tsx 에서 문제를 찾았습니다.

문제: users가 undefined일 때 .map()을 호출하고 있어요.

수정할까요? (y/n)
```

김개발은 'y'를 눌렀다.

파일이 수정되었다. 에러가 사라졌다.

**"이게... 이게 되네?"**

---

## 3장: 기억을 심다

다음 날, 김개발은 생각했다.

"Claude한테 내 스타일을 알려주면 어떨까?"

프로젝트 폴더에 파일을 만들었다.

**CLAUDE.md:**

```markdown
# 나의 코딩 스타일

- TypeScript 선호
- 함수명은 동사로 시작 (getUserData, not userData)
- 테스트 필수
- 커밋 메시지는 한국어로
```

다음부터 Claude는 이 스타일을 기억했다.

"함수명을 `fetchUserList`로 할게요. 
테스트 파일도 같이 만들까요?"

김개발은 미소 지었다.

---

## 4장: 연결의 문 — MCP

일주일 후.

"GitHub 이슈 342번 해결해줘."

```
죄송해요, GitHub에 접근 권한이 없어요.
```

선배가 다가왔다.

**"MCP 연결해야지."**

```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
```

그리고 `/mcp` 명령어로 인증.

브라우저가 열렸다. GitHub 로그인. 허용 클릭.

```
> GitHub 이슈 342번 해결해줘

📋 이슈 #342: 로그인 버튼이 모바일에서 안 보임
   assignee: @kimdev
   status: open

분석 중...

수정했습니다. PR 만들까요?
```

**"와..."**

---

## 5장: 지도 — 어디에 뭐가 있는지

김개발은 이제 전문가가 되었다. 
그가 그린 지도는 이렇다:

```
~/.claude/
├── CLAUDE.md          ← 나의 전역 설정 (모든 프로젝트)
├── settings.json      ← 권한, 환경변수
└── rules/             ← 주제별 규칙
    └── typescript.md

./project/
├── CLAUDE.md          ← 이 프로젝트 설정 (팀 공유)
├── CLAUDE.local.md    ← 내 개인 설정 (git 무시됨)
└── .mcp.json          ← MCP 서버 (팀 공유)
```

---

## 6장: 함정들

김개발은 후배들에게 경고했다.

### 함정 1: npm 설치

```bash
# ❌ 이거 하면 안 됨
npm install -g @anthropic-ai/claude-code

# ✅ 이미 설치했으면
npm uninstall -g @anthropic-ai/claude-code
```

"npm 버전은 deprecated야. 위에서 알려준 curl 써."

### 함정 2: sudo

```bash
# ❌ 절대 하지 마
sudo npm install -g anything

# 왜? 나중에 권한이 엉망이 됨
```

### 함정 3: brew --cask 빠뜨림

```bash
# ❌ 안 됨
brew install claude-code

# ✅ 됨
brew install --cask claude-code
```

"Homebrew로 설치할 거면 `--cask` 꼭 붙여."

---

## 7장: 확인하는 법

모든 설정이 끝나면:

```bash
# 버전 확인
claude --version

# 어디에 설치됐는지
which claude
# → ~/.local/bin/claude 나오면 성공

# MCP 상태
claude
> /mcp
```

---

## 에필로그: 새벽 3시의 평화

1년 후.

김개발은 여전히 새벽 3시에 코딩한다.
하지만 이제는 다르다.

```
> PR 리뷰해줘

📝 PR #127: 결제 시스템 리팩토링

리뷰 완료:
- line 42: 에러 핸들링 누락 → 수정 제안
- line 89: 성능 개선 가능 → 메모이제이션 추천
- 테스트 커버리지: 87% ✓

전체적으로 좋습니다. 위 2개만 수정하면 approve 할게요.
```

김개발은 커피를 마시며 생각했다.

**"코딩이 이렇게 편해도 되는 건가..."**

---

## 부록: 한 장 요약

| 하고 싶은 것 | 명령어 |
|-------------|--------|
| 설치 | `curl -fsSL https://claude.ai/install.sh \| bash` |
| 실행 | `claude` |
| 프로젝트 설정 | `claude` 후 `/init` |
| MCP 추가 | `claude mcp add --transport http 이름 URL` |
| MCP 상태 확인 | `/mcp` |
| 메모리 확인 | `/memory` |
| 업데이트 | `claude update` |

---

## 진짜 끝

이 여행의 핵심:

1. **설치**: 한 줄이면 끝
2. **설정**: CLAUDE.md에 원하는 거 적기
3. **연결**: MCP로 GitHub, Notion 등 연결
4. **사용**: 말로 하면 됨

**"복잡하게 생각하지 마. 그냥 해봐."**

— 김개발의 선배

---

*이 문서는 실화를 바탕으로 각색되었습니다.*
