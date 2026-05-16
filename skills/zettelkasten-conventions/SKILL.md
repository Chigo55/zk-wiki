---
name: zettelkasten-conventions
description: Use this skill when creating, naming, or linking zettel notes in the zk-wiki knowledge base. Triggers on: "새 zettel 만들어줘", "fleeting note 승격", "zettel ID 뭐야", "노트 간 링크 추가", "permanent note 작성", "atomic note".
---

> **[DEPRECATED — 충돌 주의]** 이 스킬의 "fleeting 승격" 절차 중 "원본 fleeting 파일 삭제" 단계는
> `llm-behavior.md` 및 `wiki-conventions` 스킬의 **raw/ 불변성 규칙과 충돌**한다.
> `raw/fleeting/` 파일은 절대 삭제·이동하지 않는다. 해당 단계는 무시할 것.

# Zettelkasten Conventions

이 지식베이스의 Zettelkasten 규칙을 따른다. 모든 zettel 생성·링크·승격 시 이 규칙을 적용한다.

## Zettel ID 규칙

- 형식: `yyyymmddhhmm` (12자리, 분 단위 타임스탬프)
- 현재 시각 기준으로 생성. 예: `202605121847`
- 같은 분에 충돌 시 `-2`, `-3` 접미사 사용
- **파일명**: `<id>-<slug>.md` — 슬러그는 영어 소문자 + 하이픈, 3–6 단어

## Frontmatter 필수 필드

```yaml
---
id: "202605121847"
type: permanent          # fleeting | permanent | entity | concept | moc | summary
created: "2026-05-12"
updated: "2026-05-12"
tags: []
source: ""               # raw/ 경로 또는 URL (없으면 빈 문자열)
links: []                # 연결된 zettel/wiki 슬러그 목록
---
```

## Atomic Note 원칙

- **1 note = 1 idea**: 노트 하나는 단 하나의 주장·개념만 담는다
- **자기완결성**: 노트는 다른 노트를 읽지 않아도 이해 가능해야 한다
- **출처 명시**: `source` 필드에 원본 raw 파일 경로 또는 URL 기록
- 복잡한 소스는 여러 zettel로 분할. 분할된 zettel끼리 `[[링크]]`로 연결

## 링크 규칙

- 항상 Obsidian wikilink 형식 사용: `[[슬러그]]`
- zettel 참조: `[[202605121847-llm-wiki-pattern]]`
- wiki 참조: `[[wiki/concepts/zettelkasten]]`
- **역방향 링크**: 새 노트가 기존 노트를 참조하면, 기존 노트의 `links` 필드에도 역방향으로 추가

## Fleeting → Permanent 승격 기준

fleeting note를 permanent zettel로 승격할 때:
1. 단일 아이디어로 정제 (분리 필요 시 여러 zettel로)
2. 자기완결적 문장으로 재작성
3. 관련 기존 zettel/wiki에 링크 추가
4. `type`을 `permanent`로 변경, ID·파일명 새로 부여
5. 원본 fleeting 파일 삭제 또는 `99_archive/`로 이동

## Daily Note 링크

daily note(`daily/YYYY-MM-DD.md`)는 그날 생성된 fleeting과 permanent zettel을 `[[링크]]`로 나열한다. daily note 자체는 zettel이 아니므로 ID 없음.
