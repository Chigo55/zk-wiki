---
name: clip
description: Fetch a web page, save its content to raw/articles/, then automatically run the ingest pipeline. Usage: /clip <URL>
argument-hint: <URL>
allowed-tools: WebFetch, Write, Read, Grep, Glob, Agent
---

`$ARGUMENTS` URL에서 웹 페이지 본문을 가져와 raw/articles/ 에 저장한 뒤 ingest 파이프라인을 실행한다.

## 실행 절차

1. 인자 확인: URL이 비어있으면 "사용법: /clip <URL>" 출력 후 종료.

2. **WebFetch로 본문 추출**: `$ARGUMENTS` URL 페치
   - 마크다운 형식으로 변환하여 저장

3. **파일명 생성**:
   - 페이지 제목(title)을 slug로 변환 (소문자 + 하이픈, 최대 6 단어)
   - 파일명: `raw/articles/<slug>.md`
   - 같은 이름 존재 시 타임스탬프 접미사 추가

4. **파일 저장** (`raw/articles/<slug>.md`):
```markdown
---
title: "<페이지 제목>"
url: "<URL>"
clipped: "YYYY-MM-DD"
---

<본문 마크다운>
```

5. **ingest 파이프라인 실행**: ingester agent에 위임
   - 방금 저장한 `raw/articles/<slug>.md` 경로 전달
   - ingest-pipeline 절차 전체 실행

6. 완료 후 요약 출력:
   - 저장 경로
   - 추출된 zettel 수
   - 갱신된 wiki 페이지

## 예시

```
/clip https://example.com/article-about-zettelkasten
```
