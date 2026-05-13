---
name: zk-ingest
description: Ingest a raw source file through the full zk-wiki pipeline (raw → wiki page creation → index/log). Usage: /zk-ingest <file-path>
argument-hint: <file-path>
allowed-tools: Read, Write, Edit, Grep, Glob, Agent
---

`$ARGUMENTS`에 지정된 raw 소스 파일을 ingest-pipeline을 통해 처리한다.

## 실행 절차

1. 인자 확인: `$ARGUMENTS`가 비어있으면 "사용법: /zk-ingest <raw/ 하위 파일 경로>" 출력 후 종료.

2. 파일 존재 확인: 지정된 경로가 `raw/` 하위인지 확인. 아니면 경고 출력 ("raw/ 외부 파일입니다. 계속하시겠습니까?").

3. **ingester agent**에 위임:
   - 소스 파일 경로: `$ARGUMENTS`
   - 기지식베이스 루트: 현재 작업 디렉토리
   - 적용 skill: ingest-pipeline, wiki-conventions, wiki-maintenance
   - Agent를 호출하여 6단계 파이프라인 전체 실행

4. 완료 후 요약 출력:
   - 생성/갱신된 wiki 페이지 목록
   - log.md 항목

## 예시

```
/zk-ingest raw/articles/llm-wiki-pattern.md
/zk-ingest raw/books/chapter-3.md
/zk-ingest raw/fleeting/202605131200-some-idea.md
```
