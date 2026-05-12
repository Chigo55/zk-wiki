---
name: synthesize
description: Synthesize related zettel notes into a new Map of Content (MOC) page in wiki/moc/. Usage: /synthesize <topic>
argument-hint: <topic>
allowed-tools: Read, Write, Grep, Glob, Agent
---

`$ARGUMENTS` 주제와 관련된 zettel·wiki 페이지를 모아 새로운 MOC(Map of Content) 합성 페이지를 생성한다.

## 실행 절차

1. 인자 확인: 주제가 비어있으면 "사용법: /synthesize <주제>" 출력 후 종료.

2. 기존 MOC 확인: `wiki/moc/<slug>.md` 존재 시 갱신 여부 질문.

3. **synthesizer agent**에 위임:
   - 주제: `$ARGUMENTS`
   - 검색 범위: `zettel/`, `wiki/concepts/`, `wiki/entities/`
   - 요청: 관련 페이지 수집 → 합성 MOC 작성

4. synthesizer가 생성한 `wiki/moc/<slug>.md` 확인 후 경로 출력

5. index.md 갱신: MOC 페이지 항목 추가

6. log.md에 append:
   ```
   ## [YYYY-MM-DD] synthesize | <topic>
   ```

## MOC 페이지 구조

synthesizer agent는 아래 구조로 MOC를 작성한다:
```markdown
---
id: "<timestamp>"
type: moc
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
tags: []
source: ""
links: []
---

# <Topic>

한 단락 개요.

## 핵심 주장

## 관련 Zettel

## 관련 개념

## 관련 엔티티

## 열린 질문
```

## 예시

```
/synthesize "personal knowledge management"
/synthesize "LLM 활용 패턴"
/synthesize "Zettelkasten 방법론"
```
