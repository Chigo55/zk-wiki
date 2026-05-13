---
name: wiki-maintenance
description: Use this skill when creating or updating wiki pages (entities, concepts, summaries, MOC). Triggers on: "wiki 페이지 만들어줘", "엔티티 페이지 업데이트", "개념 페이지 추가", "index.md 갱신", "위키 갱신", "summary 페이지 작성".
---

# Wiki Maintenance

`wiki/` 하위 페이지의 작성·갱신 규칙. ingest, synthesize, query 결과를 위키에 반영할 때 적용한다.

## 페이지 유형별 위치

| 유형 | 경로 | 예시 |
|---|---|---|
| 인물·도구·조직 | `wiki/entities/<slug>.md` | `wiki/entities/obsidian.md` |
| 개념·이론·패턴 | `wiki/concepts/<slug>.md` | `wiki/concepts/zettelkasten.md` |
| 소스 요약 | `wiki/summaries/<slug>.md` | `wiki/summaries/llm-wiki-pattern.md` |
| Maps of Content | `wiki/moc/<slug>.md` | `wiki/moc/personal-knowledge-management.md` |

## 페이지 템플릿

### Entity 페이지

```markdown
---
id: ""
type: entity
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
tags: []
source: ""
links: []
---

# <이름>

한 문장 정의.

## 핵심 사실

- 사실 1
- 사실 2

## 관련 개념

[[wiki/concepts/...]]

## 관련 페이지

[[wiki/...]]
```

### Concept 페이지

```markdown
---
id: ""
type: concept
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
tags: []
source: ""
links: []
---

# <개념명>

한 문장 정의.

## 설명

## 핵심 원칙

## 관련 개념

## 관련 페이지
```

### Summary 페이지

```markdown
---
id: ""
type: summary
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
tags: []
source: "raw/articles/..."
links: []
---

# 요약: <소스 제목>

**출처**: [[raw 경로 또는 URL]]
**요약 날짜**: YYYY-MM-DD

## 핵심 주장

## 주요 개념

## 관련 Wiki 페이지

## 위키 영향 (갱신된 페이지)
```

## 갱신 규칙

1. **기존 페이지 갱신**: 새 소스가 기존 entity/concept에 정보를 추가하면 해당 페이지를 갱신. 새 페이지를 만들지 않음.
2. **모순 표기**: 기존 내용과 충돌하면 `> ⚠️ 모순: <설명>` 블록으로 표시하고 두 주장을 모두 유지.
3. **`updated` 필드**: 페이지를 수정할 때마다 오늘 날짜로 갱신.
4. **역방향 링크**: 새 wiki 페이지에서 기존 페이지를 참조하면 기존 페이지의 `links`에도 역방향 추가.

## index.md 갱신

ingest 또는 synthesize 후 `index.md`에 신규/갱신 페이지를 반드시 반영한다.

항목 포맷:
```
- [[wiki/summaries/llm-wiki-pattern]] — LLM Wiki 패턴 소스 요약 (소스: 1)
```

항목이 이미 있으면 요약 텍스트와 소스 수만 갱신.
