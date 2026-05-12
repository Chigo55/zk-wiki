---
name: zk-query
description: Query the zk-wiki knowledge base and get a synthesized answer with citations. Optionally saves valuable answers as new wiki pages. Usage: /zk-query <question>
argument-hint: <question>
allowed-tools: Read, Write, Grep, Glob
---

`$ARGUMENTS`에 대한 질문을 위키 전체에서 검색하여 합성 답변을 제공한다.

## 실행 절차

1. 인자 확인: 질문이 비어있으면 "사용법: /zk-query <질문>" 출력 후 종료.

2. **index.md 읽기**: 위키 전체 카탈로그를 읽어 관련 페이지 후보 식별.

3. **관련 페이지 검색**: Grep으로 질문의 핵심 키워드를 `zettel/`, `wiki/`에서 검색.

4. **페이지 읽기**: 상위 관련 페이지(최대 10개) 내용 읽기.

5. **합성 답변 작성**:
   - 읽은 페이지 내용을 종합하여 답변
   - 각 주장에 출처 인용: `([[zettel-id-slug]])`
   - 위키에 없는 정보는 명시: "위키에 해당 정보 없음"

6. **저장 제안**: 답변이 새로운 통찰을 담고 있으면:
   > "이 답변을 `wiki/moc/<topic>.md`로 저장할까요?"
   - 사용자가 동의하면 wiki/moc/ 에 MOC 페이지로 저장
   - log.md에 `query` 항목 추가

## 예시

```
/zk-query "LLM 위키 패턴의 핵심 원칙은?"
/zk-query "Zettelkasten에서 permanent note란?"
/zk-query "ingest와 RAG의 차이점"
```
