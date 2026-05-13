# zk-wiki

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

- **Agents**: `ingester` (sonnet), `linter` (haiku), `synthesizer` (sonnet)
- **Skills**: `zettelkasten-conventions`, `wiki-maintenance`, `ingest-pipeline`, `wiki-conventions`
- **Hook**: PostToolUse — `raw/` 파일 변경 시 ingest 제안 알림

## Wiki 타입

| 타입 | 용도 | 위치 |
|---|---|---|
| concept | 단일 개념·원리·기법 | `wiki/concepts/` |
| entity | 인물·도구·조직 등 구체적 실체 | `wiki/entities/` |
| summary | raw 소스 전체 요약 | `wiki/summaries/` |
| moc | 관련 페이지를 묶는 지도 | `wiki/moc/` |

## Obsidian 연동

지식베이스 루트를 Obsidian Vault로 열면 `[[wikilink]]` 그래프 뷰를 바로 사용할 수 있다. Attachment folder path를 `raw/assets/`로 설정 권장.
