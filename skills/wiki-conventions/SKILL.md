---
name: wiki-conventions
description: Use this skill when creating, naming, or linking wiki pages in the zk-wiki knowledge base. Triggers on: "wiki 페이지 만들어줘", "노트 ID 뭐야", "노트 간 링크 추가", "fleeting 승격", "페이지 frontmatter", "wiki 노트 작성".
---

# Wiki Conventions

이 지식베이스의 wiki 페이지 작성·ID·링크 규칙. 모든 wiki 페이지 생성·링크·승격 시 이 규칙을 적용한다.

## 페이지 ID 규칙

- 형식: `yyyymmddhhmm` (12자리, 분 단위 타임스탬프)
- 현재 시각 기준으로 생성. 예: `202605121847`
- 같은 분에 충돌 시 `-2`, `-3` 접미사 사용
- **파일명**: `<id>-<slug>.md` — 슬러그는 영어 소문자 + 하이픈, 3–6 단어
- wiki 하위 디렉토리에 type에 맞게 배치: `wiki/concepts/`, `wiki/entities/`, `wiki/summaries/`, `wiki/moc/`

## Frontmatter 필수 필드

```yaml
---
id: "202605121847"
type: concept            # fleeting | entity | concept | moc | summary
created: "2026-05-12"
updated: "2026-05-12"
tags: []
source: ""               # raw/ 경로 또는 URL (없으면 빈 문자열)
links: []                # 연결된 wiki 슬러그 목록
---
```

## Atomic Note 원칙

- **1 page = 1 idea**: 페이지 하나는 단 하나의 주장·개념만 담는다
- **자기완결성**: 페이지는 다른 페이지를 읽지 않아도 이해 가능해야 한다
- **출처 명시**: `source` 필드에 원본 raw 파일 경로 또는 URL 기록
- 복잡한 소스는 여러 concept/entity 페이지로 분할 후 `[[링크]]`로 연결

## 링크 규칙

- 항상 Obsidian wikilink 형식 사용: `[[슬러그]]`
- wiki 참조: `[[wiki/concepts/zettelkasten]]`, `[[wiki/entities/obsidian]]`
- **역방향 링크**: 새 페이지가 기존 페이지를 참조하면, 기존 페이지의 `links` 필드에도 역방향으로 추가

## Fleeting → Wiki 승격 기준

`raw/fleeting/` 의 fleeting note를 wiki 페이지로 승격할 때:
1. 아이디어 유형 결정: concept, entity, summary, moc 중 하나
2. 자기완결적 문장으로 재작성
3. 적절한 wiki 하위 디렉토리에 새 파일 생성 (wiki/concepts/ 또는 wiki/entities/ 등)
4. 관련 기존 wiki 페이지에 링크 추가
5. **raw/fleeting/ 원본 파일은 수정·삭제하지 않음** (raw/ 불변성 규칙)
