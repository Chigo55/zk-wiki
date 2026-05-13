---
name: fleeting
description: Capture a quick fleeting note instantly to raw/fleeting/ directory. No classification or linking — just capture the idea. Usage: /fleeting <text>
argument-hint: <text>
allowed-tools: Write, Bash
---

`$ARGUMENTS` 텍스트를 즉시 fleeting note 파일로 저장한다.

## 실행 절차

1. 인자 확인: 텍스트가 비어있으면 "사용법: /fleeting <메모할 내용>" 출력 후 종료.

2. 파일명 생성:
   - 현재 타임스탬프: `yyyymmddhhmm` 형식 (PowerShell: `Get-Date -Format "yyyyMMddHHmm"`)
   - 슬러그: `$ARGUMENTS`의 첫 4–5 단어를 소문자 + 하이픈으로 변환
   - 파일명: `raw/fleeting/<timestamp>-<slug>.md`

3. 파일 내용:
```markdown
---
id: "<timestamp>"
type: fleeting
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
tags: []
source: ""
links: []
---

<$ARGUMENTS 전체 텍스트>
```

4. 저장 완료 후 출력:
   > "`raw/fleeting/<파일명>` 저장 완료. `/zk-ingest raw/fleeting/<파일명>`으로 위키에 반영 가능."

분류·링크·wiki 갱신은 하지 않는다. 나중에 `/zk-ingest`로 위키 페이지로 승격.

## 예시

```
/fleeting "LLM이 지식베이스를 유지하는 핵심은 maintenance 비용이 0에 가깝다는 것"
/fleeting "Obsidian graph view가 wiki 구조 파악에 유용"
```
