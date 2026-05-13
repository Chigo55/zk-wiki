---
name: ingest-pipeline
description: Use this skill when processing a raw source through the full ingest pipeline (raw → wiki pages). Triggers on: "/zk-ingest", "소스 인제스트", "raw 파일 처리", "새 소스 추가", "위키에 추가", "fleeting 승격".
---

# Ingest Pipeline

raw 소스 1건을 받아 wiki 페이지 생성 → index/log 기록까지 완전히 처리하는 절차.

## 6단계 파이프라인

### 1단계: raw 소스 읽기

- `raw/` 하위 파일을 Read 도구로 읽는다 (`raw/fleeting/` 포함)
- **raw/ 파일은 절대 수정·삭제하지 않는다**
- 소스 유형 파악: 아티클, 책 챕터, 논문, 강의 노트, fleeting 메모 등

### 2단계: 핵심 명제 추출

- 소스에서 독립적으로 가치 있는 아이디어·주장·사실 목록 작성
- 각 명제는 1–2 문장으로 표현
- 너무 세부적이거나 예시에 불과한 내용은 제외
- 목표: 5–15개 명제 (소스 길이에 따라 조정)

### 3단계: 중복 검사

- 추출된 각 명제에 대해 `wiki/` 디렉토리를 Grep으로 검색
- 유사한 내용의 기존 wiki 페이지가 있으면:
  - 새 정보를 기존 페이지에 **합산 갱신** (새 파일 생성 X)
  - `updated` 날짜 갱신
  - `source` 필드에 새 소스 추가
- 중복 없으면 새 페이지 생성

### 4단계: wiki 페이지 신규/갱신

- 소스에서 등장한 entity(도구·인물·조직)와 concept(개념·이론)을 식별
- wiki-conventions 규칙 적용:
  - `type: concept` → `wiki/concepts/<slug>.md`
  - `type: entity` → `wiki/entities/<slug>.md`
  - 기존 wiki 페이지 있으면 갱신, 없으면 신규 생성
- 소스 전체 요약 페이지 `wiki/summaries/<slug>.md` 작성

### 5단계: Cross-link 연결

- 새로 만든/갱신한 wiki 페이지 간 `[[링크]]` 연결
- 관련 기존 페이지에도 역방향 링크 추가
- 연결 기준: 동일 개념 참조, 인과관계, 반론/보완 관계

### 6단계: index.md + log.md 기록

index.md:
- 신규 wiki 페이지 항목 추가
- 기존 항목 있으면 갱신

log.md에 append:
```
## [YYYY-MM-DD] ingest | <소스 제목>
```

## 체크리스트 (완료 조건)

- [ ] raw 파일 읽기 완료
- [ ] wiki 페이지 N개 생성/갱신
- [ ] summary 페이지 1개 생성
- [ ] entity/concept 페이지 신규/갱신
- [ ] cross-link 연결
- [ ] index.md 갱신
- [ ] log.md 항목 추가

## 오류 처리

- **raw 파일 없음**: 오류 메시지 출력. 작업 중단.
- **파싱 불가 형식**: 가능한 범위까지 처리하고 한계 명시.
- **중복 판단 불확실**: 새 파일 생성하고 기존 파일과 `[[링크]]`로 연결 후 사용자에게 병합 여부 질문.
