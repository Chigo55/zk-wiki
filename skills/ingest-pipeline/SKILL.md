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

**실패 처리 (엄격)**:
- Read 결과가 비어 있거나 오류가 발생하면 **즉시 작업 중단**.
- 환경 일반 지식이나 추정으로 wiki 페이지를 작성하는 것은 **절대 금지**.
- 실패 이유와 파일 경로를 상위 호출자에게 보고한다.

### 2단계: 핵심 명제 추출

- 소스에서 독립적으로 가치 있는 아이디어·주장·사실 목록 작성
- 각 명제는 1–2 문장으로 표현
- 너무 세부적이거나 예시에 불과한 내용은 제외
- 목표: 5–15개 명제 (소스 길이에 따라 조정)

### 3단계: 중복 검사 (필수 — 건너뛰지 않는다)

추출된 각 명제에 대해 아래 체크리스트를 **순서대로** 수행한다:

- [ ] 명제에서 핵심 명사구를 추출하여 정규화된 후보 slug 목록 생성 (예: "사물인터넷 정의" → `사물인터넷-정의`)
- [ ] 각 후보 slug와 주요 키워드로 `wiki/concepts/`, `wiki/entities/`, `wiki/summaries/` 전 디렉토리를 Grep
- [ ] 매칭 파일이 있으면:
  - 내용을 읽어 실제 동일/유사 개념인지 확인
  - 동일 개념이면 **새 파일 생성 금지** — 기존 파일에 새 정보를 합산 갱신, `updated` 날짜 갱신, `source` 필드에 새 소스 추가
- [ ] 매칭이 불확실(유사 제목이지만 다른 개념 가능성)하면 사용자에게 질문 후 진행
- [ ] 매칭 없음이 확인된 경우에만 새 페이지 생성

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

- [ ] raw 파일 읽기 완료 (실패 시 중단)
- [ ] wiki 페이지 N개 생성/갱신
- [ ] summary 페이지 1개 생성
- [ ] entity/concept 페이지 신규/갱신
- [ ] cross-link 연결
- [ ] index.md 갱신
- [ ] log.md 항목 추가

## 오류 처리

- **raw 파일 없음**: 오류 메시지 출력. 작업 중단.
- **Read 실패 또는 빈 결과**: 오류 메시지 출력. 작업 중단. 일반 지식으로 대체 작성 금지.
- **파싱 불가 형식**: 오류 메시지 출력. 작업 중단. (PDF는 hook이 자동 변환하므로 .txt로 재시도 안내가 왔을 경우 그 경로를 읽는다)
- **중복 판단 불확실**: 새 파일 생성하고 기존 파일과 `[[링크]]`로 연결 후 사용자에게 병합 여부 질문.
