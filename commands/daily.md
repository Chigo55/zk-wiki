---
name: daily
description: Create or open today's daily note in daily/ directory. Auto-embeds today's fleeting notes and links to yesterday. Usage: /daily
allowed-tools: Read, Write, Glob
---

오늘 날짜의 daily note를 생성하거나 이미 있으면 내용을 보여준다.

## 실행 절차

1. 오늘 날짜 확인: `YYYY-MM-DD` 형식

2. `daily/<today>.md` 존재 여부 확인 (Glob 사용)

3. **이미 있으면**: 파일을 Read하여 내용 출력.

4. **없으면** 파일 생성:

```markdown
---
date: "YYYY-MM-DD"
type: daily
---

# YYYY-MM-DD

## 오늘의 Fleeting Notes

<오늘 fleeting/ 에 있는 파일들을 [[링크]]로 나열>

## 오늘의 Permanent Zettel

<오늘 생성된 zettel/ 파일들을 [[링크]]로 나열>

## 메모

```

5. fleeting 임베드 방법:
   - `fleeting/<today>-*.md` 패턴으로 Glob
   - 각 파일을 `- [[fleeting/<파일명>]]` 형식으로 나열
   - 없으면 "_없음_" 표시

6. 어제 날짜 daily note 링크 추가: `← [[daily/<yesterday>]]`

7. 완료 후: "`daily/<today>.md` 생성/열기 완료."

## 예시

```
/daily
```
