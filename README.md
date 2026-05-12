# zk-wiki

Zettelkasten + LLM Wiki 하이브리드 지식베이스 플러그인.

raw 소스를 자동으로 atomic zettel로 분해하고 wiki 페이지를 점진적으로 유지보수한다. 개인 학습/연구 + 일상 메모 통합 워크플로우.

## 전제 조건

이 플러그인은 아래 디렉토리 구조가 **이미 존재**하는 것을 전제로 한다. 처음 사용 시 아래 구조를 생성하거나 CLAUDE.md를 참조한다.

```
<지식베이스 루트>/
├─ raw/articles/
├─ raw/books/
├─ raw/assets/
├─ fleeting/
├─ daily/
├─ zettel/
├─ wiki/entities/
├─ wiki/concepts/
├─ wiki/moc/
├─ wiki/summaries/
├─ index.md
└─ log.md
```

## 명령어

| 명령 | 인자 | 설명 |
|---|---|---|
| `/zk-ingest` | `<file-path>` | raw 소스 → zettel + wiki 파이프라인 |
| `/zk-query` | `<question>` | 위키 검색·합성 답변 |
| `/zk-lint` | — | 위키 건강 검진 |
| `/fleeting` | `<text>` | 빠른 메모 즉시 캡처 |
| `/daily` | — | 오늘 daily note 생성/열기 |
| `/clip` | `<URL>` | 웹 페이지 → raw → ingest |
| `/synthesize` | `<topic>` | 관련 zettel → MOC 합성 노트 |

## 예시 워크플로우

```
# 웹 아티클 클리핑 + 자동 처리
/clip https://example.com/article

# 로컬 파일 직접 인제스트
/zk-ingest raw/books/chapter-3.md

# 빠른 메모
/fleeting "인상 깊었던 아이디어 한 줄"

# 오늘 daily note
/daily

# 주제별 합성
/synthesize "Zettelkasten 방법론"

# 위키 건강 검진
/zk-lint
```

## 컴포넌트

- **Skills**: `zettelkasten-conventions`, `wiki-maintenance`, `ingest-pipeline`
- **Agents**: `ingester` (sonnet), `linter` (haiku), `synthesizer` (sonnet)
- **Hook**: PostToolUse — `raw/` 파일 변경 시 ingest 제안 알림

## Obsidian 연동

지식베이스 루트를 Obsidian Vault로 열면 `[[wikilink]]` 그래프 뷰를 바로 사용할 수 있다. Attachment folder path를 `raw/assets/`로 설정 권장.
