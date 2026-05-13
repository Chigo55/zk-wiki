# zk-wiki `v0.3.1`

Zettelkasten + LLM Wiki 하이브리드 지식베이스 플러그인.

raw 소스를 자동으로 atomic zettel로 분해하고 wiki 페이지를 점진적으로 유지보수한다.

## 전제 조건

이 플러그인은 아래 디렉토리 구조가 **이미 존재**하는 것을 전제로 한다.

```
<지식베이스 루트>/
├─ raw/
│   ├─ articles/
│   ├─ books/
│   ├─ assets/
│   └─ fleeting/
├─ wiki/
│   ├─ concepts/
│   ├─ entities/
│   ├─ summaries/
│   └─ moc/
├─ .claude/
│   ├─ rules/          # LLM 행동 규칙 + 컨벤션
│   └─ template/       # wiki 페이지 템플릿
├─ index.md
└─ log.md
```

## 명령어

| 명령 | 인자 | 설명 |
|---|---|---|
| `/zk-wiki:zk-ingest` | `<file-path>` | raw 소스 → wiki 파이프라인 |
| `/zk-wiki:zk-lint` | — | wiki 건강 검진 |
| `/zk-wiki:fleeting` | `<text>` | 빠른 메모 즉시 캡처 |
| `/zk-wiki:clip` | `<URL>` | 웹 페이지 → raw → ingest |
| `/zk-wiki:synthesize` | `<topic>` | 관련 zettel → MOC 합성 |
| `/zk-wiki:zk-query` | `<question>` | wiki 검색·합성 답변 |

## 예시 워크플로우

```
# 로컬 파일 인제스트
/zk-wiki:zk-ingest raw/fleeting/202605121919-메모.md

# 웹 아티클 클리핑 + 자동 처리
/zk-wiki:clip https://example.com/article

# 빠른 메모
/zk-wiki:fleeting "인상 깊었던 아이디어 한 줄"

# 주제별 MOC 합성
/zk-wiki:synthesize "Zettelkasten 방법론"

# wiki 건강 검진
/zk-wiki:zk-lint
```

## 컴포넌트

명령은 에이전트에 위임되고, 에이전트는 스킬을 지식 베이스로 로드한다.

### Agents

| 에이전트 | 모델 | 역할 | 사용 스킬 |
|---|---|---|---|
| `ingester` | claude-sonnet-4-6 | raw 소스 → wiki 6단계 파이프라인 | ingest-pipeline, wiki-conventions, wiki-maintenance |
| `linter` | haiku | 읽기 전용 건강 검진, 파일 수정 없음 | — |
| `synthesizer` | claude-sonnet-4-6 | 관련 페이지 수집 → MOC 생성 | wiki-maintenance, wiki-conventions |

### Skills

| 스킬 | 설명 |
|---|---|
| `ingest-pipeline` | 6단계 ingest 파이프라인 로직 |
| `wiki-conventions` | 페이지 ID 형식, frontmatter 스키마, atomic note 규칙 |
| `wiki-maintenance` | 페이지 타입별 템플릿, 업데이트 규칙, 역방향 링크 프로토콜 |
| `zettelkasten-conventions` | fleeting → permanent 승격 기준 |

### Hooks

`hooks/hooks.json` 현재 비어 있음. `raw/` 파일 변경 시 ingest 제안 알림(PostToolUse) 구현 예정.

## Wiki 타입

| 타입 | 용도 | 위치 |
|---|---|---|
| concept | 단일 개념·원리·기법 | `wiki/concepts/` |
| entity | 인물·도구·조직 등 구체적 실체 | `wiki/entities/` |
| summary | raw 소스 전체 요약 | `wiki/summaries/` |
| moc | 관련 페이지를 묶는 지도 | `wiki/moc/` |

## Ingest 파이프라인 (6단계)

`/zk-ingest` 및 `/clip` 실행 시 ingester 에이전트가 아래 순서로 처리한다.

1. **raw 소스 읽기** — `raw/` 파일 읽기 (수정 불가)
2. **핵심 명제 추출** — 독립적인 아이디어 5–15개 식별
3. **중복 검사** — `wiki/` 내 유사 내용 검색, 근접 중복 시 기존 페이지 갱신
4. **wiki 페이지 생성·갱신** — summaries / entities / concepts 디렉토리에 작성
5. **상호 링크** — 관련 페이지 간 `[[wikilink]]` 추가, 기존 페이지에 역방향 링크 삽입
6. **index.md · log.md 갱신** — 항목 추가 및 작업 이력 한 줄 append

## Obsidian 연동

지식베이스 루트를 Obsidian Vault로 열면 `[[wikilink]]` 그래프 뷰를 바로 사용할 수 있다. Attachment folder path를 `raw/assets/`로 설정 권장.
