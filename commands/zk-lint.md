---
name: zk-lint
description: Health-check the zk-wiki knowledge base. Detects orphan pages, broken links, missing cross-references, contradictions, and data gaps. Usage: /zk-lint
allowed-tools: Read, Grep, Glob, Agent
---

위키 전체 건강 검진을 실행한다. **linter agent**에 위임하여 보고서를 생성한다.

## 실행 절차

1. **linter agent** 호출:
   - 검사 범위: `zettel/`, `wiki/`, `index.md`
   - 검사 항목 전달 (아래 참조)

2. 보고서 출력:
   - 심각(Critical): 깨진 링크, 존재하지 않는 파일 참조
   - 경고(Warning): orphan 페이지, 누락된 cross-reference
   - 정보(Info): index.md에 없는 페이지, 업데이트 오래된 페이지

3. log.md에 append:
   ```
   ## [YYYY-MM-DD] lint | 검사 완료 (Critical: N, Warning: N)
   ```

## linter가 확인하는 항목

- **Orphan 페이지**: inbound link가 0인 zettel/wiki 페이지
- **깨진 링크**: `[[링크]]` 대상 파일이 존재하지 않음
- **index.md 누락**: `zettel/`·`wiki/` 에 있지만 index.md에 없는 페이지
- **모순 감지**: 동일 주제에서 상충하는 주장이 있는 페이지 쌍
- **요약 없는 raw 소스**: `raw/`에 있지만 `wiki/summaries/`에 요약 없는 파일
- **링크 없는 zettel**: `links: []`이고 본문에도 `[[링크]]` 없는 permanent note

## 예시

```
/zk-lint
```
