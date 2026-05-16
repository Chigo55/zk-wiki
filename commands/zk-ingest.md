---
name: zk-ingest
description: Ingest one or more raw source files through the full zk-wiki pipeline (raw → wiki page creation → index/log). Usage: /zk-ingest <file-path-or-glob>
argument-hint: <file-path-or-glob>
allowed-tools: Read, Write, Edit, Grep, Glob, Agent
---

`$ARGUMENTS`에 지정된 raw 소스를 ingest-pipeline을 통해 처리한다.

## 실행 절차

1. **인자 확인**: `$ARGUMENTS`가 비어있으면 "사용법: /zk-ingest <raw/ 하위 파일 경로 또는 glob>" 출력 후 종료.

2. **파일 목록 확정**:
   - `$ARGUMENTS`에 와일드카드(`*`, `?`)가 포함되어 있으면 Glob 도구로 매칭되는 파일 목록을 수집하고 정렬.
   - 단일 파일이면 그대로 사용.
   - 지정된 경로가 `raw/` 하위인지 확인. 아니면 경고 출력 ("raw/ 외부 파일입니다. 계속하시겠습니까?").

3. **순차 처리 (병렬 위임 절대 금지)**:
   - 파일 목록을 **하나씩** ingester agent에 위임.
   - 한 파일의 ingest가 완전히 완료된 것을 확인한 후 다음 파일로 진행.
   - **어떠한 경우에도 ingester agent를 동시에 2개 이상 실행하지 않는다.** 속도를 이유로 병렬화하지 않는다.
   - 각 위임 시 전달 정보:
     - 소스 파일 경로
     - 기지식베이스 루트: 현재 작업 디렉토리

4. **전체 완료 후 lint**:
   - 모든 파일 처리가 끝나면 **linter agent를 자동 호출**하여 중복 의심 페이지, 깨진 링크, 누락 항목을 확인.
   - linter 보고를 사용자에게 출력.

5. **최종 요약 출력**:
   - 생성/갱신된 wiki 페이지 전체 목록
   - 중복 검사에서 기존 페이지를 갱신한 항목
   - log.md 항목

## 중요 규칙

- **PDF 파일은 hook이 자동 변환**한다. `.pdf` 경로를 그대로 넘겨도 `block-pdf-read` hook이 pdftotext로 변환하고 `.zk-cache/<stem>.txt`를 읽도록 안내한다.
- **raw/ 하위 파일은 절대 수정·삭제하지 않는다.**
- ingester가 Read 실패를 보고하면 해당 파일을 건너뛰고 다음 파일로 진행한 뒤 사용자에게 실패 목록을 보고한다.

## 예시

```
/zk-ingest raw/articles/llm-wiki-pattern.md
/zk-ingest raw/books/chapter-3.md
/zk-ingest raw/books/Internet\ of\ Things/*.txt
/zk-ingest raw/fleeting/202605131200-some-idea.md
```
