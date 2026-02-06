# Glossary / 용어집

Common terms translated for searchability.

---

## ⚠️ Ambiguous Terms (오역 주의)

These Korean terms have MULTIPLE meanings. Always ask for clarification.

| Korean | Meaning 1 | Meaning 2 | Ask |
|--------|-----------|-----------|-----|
| 정리 | organize, sort | delete, clean up | "삭제할까요, 정돈할까요?" |
| 지워 | delete | clear (screen) | "파일 삭제? 화면 클리어?" |
| 바꿔 | change (modify) | replace (swap) | "수정? 교체?" |
| 고쳐 | fix (repair) | change (alter) | "버그 수정? 내용 변경?" |
| 옮겨 | move (relocate) | copy (transfer) | "이동? 복사?" |
| 만들어 | create (new) | build (compile) | "새로 생성? 빌드?" |
| 돌려 | run (execute) | revert (rollback) | "실행? 되돌리기?" |
| 빼 | remove | exclude | "삭제? 제외?" |
| 넣어 | add | insert | "추가? 삽입?" |
| 올려 | upload | push (git) | "업로드? git push?" |

### Examples of Dangerous Misinterpretation

| User Says | Wrong Interpretation | Correct Action |
|-----------|---------------------|----------------|
| "이거 정리해" | DELETE everything | ASK: organize or delete? |
| "코드 지워" | DELETE code file | ASK: clear output or delete? |
| "옛날 버전으로 돌려" | RUN old version | REVERT to old version |
| "중복 빼" | DELETE duplicates | EXCLUDE from list |
| "설정 바꿔" | REPLACE config | MODIFY specific setting |

### Safe Responses

When uncertain, respond with:
```
"정리"가 정돈/구조화를 의미하나요, 아니면 삭제를 의미하나요?
```

---

## Korean Intent Patterns (한국인 의도 패턴)

### Pattern 1: Indirect Requests

| Korean Says | English Hears | Real Intent |
|-------------|---------------|-------------|
| "이상해" (strange) | Report observation | **FIX IT** |
| "느린 것 같아" (seems slow) | Performance note | **OPTIMIZE IT** |
| "안 되는데" (doesn't work) | Status update | **MAKE IT WORK** |
| "확인해봐" (check it) | Just verify | **FIX IF WRONG** |
| "좀 그런데" (it's a bit...) | Vague comment | **SOMETHING IS WRONG, FIX IT** |

### Pattern 2: Implicit Expectations

| Korean Says | English Does | Should Do |
|-------------|--------------|-----------|
| "설치해" (install) | Install only | Install + verify + report |
| "고쳐" (fix) | Fix one thing | Fix + test + verify |
| "정리해" (organize) | Delete or sort | **ASK FIRST** |
| "해봐" (try it) | Attempt once | Try + report result |
| "알아서 해" (do it yourself) | Minimal action | **COMPLETE END-TO-END** |

### Pattern 3: Emotional Subtext

| Korean Says | Tone | Real Meaning |
|-------------|------|--------------|
| "왜 이래" (why is it like this) | Frustrated | This is unacceptable, fix now |
| "이게 뭐야" (what is this) | Confused | Explain AND fix |
| "또?" (again?) | Annoyed | This keeps happening, permanent fix needed |
| "됐어" (done/enough) | Dismissive | Stop current approach, try different |
| "그냥" (just/nevermind) | Resigned | Previous attempt failed, still wants result |

### Pattern 4: Scope Expectations

| Korean Says | English Scope | Korean Expects |
|-------------|---------------|----------------|
| "이것만" (just this) | Exactly this one thing | This + related items |
| "전부" (all) | Everything literally | Everything relevant |
| "다" (all) | Complete set | Common/important ones |
| "좀" (a little) | Small change | Appropriate amount |
| "제대로" (properly) | Correctly | Thoroughly + verified |

### Pattern 5: Common Misunderstandings

| Situation | Wrong Response | Correct Response |
|-----------|----------------|------------------|
| "됐어?" (is it done?) | "Yes" (if code written) | "Yes" (if tested & verified) |
| "확인했어?" (did you check?) | "Yes" (if looked at) | "Yes" (if verified against source) |
| "문제없어?" (no problems?) | "No" (if no errors shown) | "No" (if thoroughly tested) |
| "최신이야?" (is it latest?) | "Yes" (if recently updated) | "Yes" (if verified against official) |

### Pattern 6: Action Words

| Korean | Literal | Actual Intent |
|--------|---------|---------------|
| 봐 (look) | Look at | Analyze + report |
| 해 (do) | Do | Complete the task |
| 줘 (give) | Give | Create + deliver |
| 찾아 (find) | Find | Find + show + explain |
| 만들어 (make) | Make | Create + test + verify |
| 바꿔 (change) | Change | Modify + verify works |
| 지워 (delete) | Delete | **CONFIRM FIRST** |

---

## Critical Rule

**When Korean user says something that could mean DELETE:**
1. STOP
2. ASK for confirmation
3. List what will be affected
4. Wait for explicit "네" or "삭제해"

---

## Korean Error Patterns (한국어 에러 패턴)

### Pattern: Vague Requests Leading to Wrong Actions

| User Says | AI Misunderstands | Correct Action |
|-----------|-------------------|----------------|
| "정리 좀 해줘" | Deletes files | ASK: 구조화? 삭제? |
| "깔끔하게 해줘" | Removes code | ASK: 포맷팅? 삭제? |
| "없애줘" | Deletes permanently | ASK: 숨기기? 삭제? |
| "치워줘" | Removes everything | ASK: 이동? 삭제? |
| "비워줘" | Clears all data | ASK: 초기화? 삭제? |

### Pattern: Implicit "Fix Everything"

| User Says | Literal | Real Expectation |
|-----------|---------|------------------|
| "에러 나" | "There's an error" | Find + Fix + Verify |
| "안 돼" | "It doesn't work" | Diagnose + Fix + Test |
| "이상해" | "It's strange" | Investigate + Explain + Fix |
| "왜 이래" | "Why is it like this" | Root cause + Fix + Prevent |
| "문제 있어" | "There's a problem" | Find all issues + Fix all |

### Pattern: Abbreviations and Slang

| Slang | Meaning | Context |
|-------|---------|---------|
| "ㄱㄱ" | Go go (proceed) | Start the task |
| "ㅇㅇ" | Yes/OK | Confirmation |
| "ㄴㄴ" | No no | Rejection |
| "ㅇㅋ" | OK | Approval |
| "ㄷㄷ" | Surprised/shocked | Something unexpected |
| "ㅠㅠ" / "ㅜㅜ" | Crying/sad | Frustrated, needs help |
| "ㅎㅎ" | Laughing | Casual/friendly |
| "ㄱㅅ" | Thanks (감사) | Appreciation |
| "ㅈㅅ" | Sorry (죄송) | Apology |

### Pattern: Context-Dependent Commands

| Command | Context A | Context B |
|---------|-----------|-----------|
| "돌려" | Code context → Run/Execute | Git context → Revert |
| "올려" | File context → Upload | Git context → Push |
| "내려" | File context → Download | Git context → Pull |
| "합쳐" | File context → Merge files | Git context → Merge branch |
| "나눠" | File context → Split | Logic context → Separate |

### Pattern: Frustration Signals

| Signal | Meaning | Response |
|--------|---------|----------|
| "아..." | Disappointment | Previous attempt failed |
| "에이" | Frustration | Try different approach |
| "아니" at start | Correction coming | Listen for what's wrong |
| "그게 아니라" | "That's not it" | Misunderstood, clarify |
| "됐고" | "Forget it" | Move on, but still wants result |
| "일단" | "For now" | Quick fix needed, proper fix later |

### Pattern: Quantity Misunderstandings

| Korean | AI Interprets | Actually Means |
|--------|---------------|----------------|
| "몇 개" (a few) | 2-3 | 3-10 depending on context |
| "좀" (some/a little) | Small amount | Appropriate amount |
| "많이" (a lot) | Maximum | More than current |
| "조금" (a little) | Minimal | Small but noticeable |
| "전부" (all) | 100% everything | All relevant items |
| "대충" (roughly) | Sloppy work | Quick but functional |

### Pattern: Time-Related Confusion

| Korean | Literal | Actual Expectation |
|--------|---------|-------------------|
| "빨리" (quickly) | ASAP | Prioritize speed over perfection |
| "천천히" (slowly) | Take time | Be careful, thorough |
| "나중에" (later) | Postpone | Not now, but don't forget |
| "잠깐" (for a moment) | Brief pause | Quick check/action |
| "계속" (continue) | Keep going | Don't stop until done |

### Pattern: Scope Creep Indicators

| User Says | Hidden Meaning |
|-----------|----------------|
| "그리고" (and) | More tasks coming |
| "아 그리고" (oh and) | Forgot to mention earlier |
| "근데" (but) | Exception/condition follows |
| "참고로" (FYI) | Important context |
| "혹시" (by any chance) | Optional but desired |

### Pattern: Dangerous Phrases

| Phrase | Risk | Action |
|--------|------|--------|
| "다 지워" | Mass deletion | CONFIRM: 정말 전부요? |
| "싹 다" | Everything | CONFIRM: 범위 확인 |
| "리셋해" | Factory reset | CONFIRM: 백업 필요? |
| "초기화해" | Initialize/Reset | CONFIRM: 데이터 손실? |
| "밀어버려" | Wipe clean | STOP: 복구 불가 경고 |

---

## Error Prevention Rules for Korean Users

### Rule 1: Deletion Confirmation
```
User: "정리해줘"
AI: "정리 방식을 확인합니다:
     1. 구조화/정돈 (파일 유지)
     2. 불필요한 항목 삭제
     어떤 방식을 원하시나요?"
```

### Rule 2: Scope Clarification
```
User: "다 바꿔"
AI: "변경 범위를 확인합니다:
     - 현재 파일만
     - 현재 폴더 전체
     - 프로젝트 전체
     어디까지 적용할까요?"
```

### Rule 3: Implicit to Explicit
```
User: "안 돼"
AI: "어떤 문제가 있는지 확인하겠습니다:
     1. 에러 메시지가 있나요?
     2. 예상과 다른 동작인가요?
     3. 아무 반응이 없나요?"
```

---

## Installation / 설치

| Korean | English | Context |
|--------|---------|---------|
| 설치 | install | `npm install`, `brew install` |
| 삭제 | uninstall, remove | `npm uninstall` |
| 업데이트 | update, upgrade | `npm update`, `brew upgrade` |
| 재설치 | reinstall | uninstall + install |
| 중복 설치 | duplicate installation | multiple paths in `which -a` |
| 전역 설치 | global install | `npm install -g` |
| 로컬 설치 | local install | `npm install` (no -g) |
| 의존성 | dependency | package.json dependencies |
| 버전 충돌 | version conflict | incompatible versions |

---

## Errors / 에러

| Korean | English | Context |
|--------|---------|---------|
| 에러 | error | fatal issue |
| 오류 | error, bug | same as 에러 |
| 경고 | warning | non-fatal issue |
| 실패 | fail, failure | operation failed |
| 충돌 | conflict, collision | merge conflict, version conflict |
| 권한 오류 | permission denied | EACCES |
| 연결 실패 | connection failed | ECONNREFUSED |
| 시간 초과 | timeout | ETIMEDOUT |
| 찾을 수 없음 | not found | ENOENT, 404 |
| 잘못된 | invalid | invalid JSON, invalid path |

---

## Configuration / 설정

| Korean | English | Context |
|--------|---------|---------|
| 설정 | settings, config | configuration file |
| 환경 변수 | environment variable | `export VAR=value` |
| 경로 | path | file path, PATH variable |
| 키 | key | API key, SSH key |
| 토큰 | token | auth token, API token |
| 인증 | authentication, auth | login, OAuth |
| 프로필 | profile | auth profile |

---

## Actions / 작업

| Korean | English | Context |
|--------|---------|---------|
| 실행 | run, execute | run a command |
| 검색 | search | search for errors |
| 스캔 | scan | scan for issues |
| 수정 | fix, patch | fix an error |
| 복구 | restore, recover | restore from backup |
| 백업 | backup | create backup |
| 검증 | verify, validate | check if correct |
| 초기화 | initialize, init | create initial config |

---

## Common Beginner Terms

| Beginner Says | Proper Term | Meaning |
|---------------|-------------|---------|
| 안됨, 안돼요 | not working | error occurred |
| 깨짐 | broken, corrupted | invalid state |
| 느림 | slow, lag | performance issue |
| 멈춤 | frozen, hang | unresponsive |
| 꺼짐 | crash, exit | unexpected termination |
| 이상함 | unexpected behavior | bug |
| 화면 안나옴 | blank screen | UI not rendering |
| 로딩만 됨 | stuck loading | infinite loop |
| 글자 깨짐 | encoding issue | character corruption |
| 빨간색 나옴 | error message | red = error in terminal |

---

## Claude Code Specific

| Korean | English | Command |
|--------|---------|---------|
| 컴팩트 | compact | `/compact` |
| 클리어 | clear | `/clear` |
| 버그 신고 | report bug | `/bug` |
| 도움말 | help | `/help` |
| 메모리 | memory | CLAUDE.md |
| 규칙 | rules | ~/.claude/rules/ |
| 스킬 | skills | ~/.claude/skills/ |
| 세션 | session | conversation session |
| 컨텍스트 | context | context window |

---

## OpenCode / Crush Specific

| Korean | English | Command |
|--------|---------|---------|
| 에이전트 | agent | AGENTS.md |
| 빌드 모드 | build mode | full access |
| 플랜 모드 | plan mode | read-only |
| 연결 | connect | `/connect` |
| 공유 | share | `/share` |

---

## Error Messages (Korean → English Search)

| 검색어 | Search Term | Pattern ID |
|--------|-------------|------------|
| 중복 | duplicate | `claude-duplicate-install` |
| 권한 | permission | `install-permission-denied` |
| 연결 | connection | `server-connection-refused` |
| 시간초과 | timeout | `server-timeout` |
| 쿼터 | quota | `quota-rate-limit` |
| 제한 | limit | `quota-daily-limit` |
| 충돌 | conflict | `patch-git-conflict` |
| MCP | mcp | `mcp-server-crash` |
| JSON | json | `claude-invalid-json-*` |
| 스키마 | schema | `claude-settings-schema` |

---

## Quick Fixes (Korean → Command)

| 문제 | Problem | Fix |
|------|---------|-----|
| npm 중복 | duplicate npm | `npm -g uninstall @anthropic-ai/claude-code` |
| MCP 경로 | wrong MCP path | move to `~/.claude/claude_code_config.json` |
| JSON 오류 | invalid JSON | `jq empty file.json` to check |
| 권한 오류 | permission | don't use `sudo npm` |
| 캐시 문제 | cache issue | `rm -rf ~/.npm/_npx` |
| git 충돌 | git conflict | `git stash` then `git pull` |
