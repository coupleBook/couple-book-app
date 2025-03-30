# Couple Book App

## 프로젝트 구조

```
lib/
├── core/                    # 핵심 기능
│   ├── constants/           # 상수 정의
│   ├── l10n/                # 다국어 처리
│   ├── errors/              # 에러 처리
│   ├── network/             # 네트워크 관련
│   ├── routing/             # 라우팅
│   ├── theme/               # 테마
│   └── utils/               # 유틸리티 함수
│
├── data/                    # 데이터 계층
│   ├── local/               # 로컬 데이터
│   │   ├── datasources/     # 데이터 소스
│   │   └── entities/        # 엔티티
│   ├── remote/              # 원격 데이터
│   │   ├── datasources/     # 데이터 소스
│   │   └── models/          # 모델
│   └── repositories/        # 리포지토리 구현체
│   └── storage/             # 로컬 저장소
│
├── domain/                  # 도메인 계층
│   ├── entities/            # 도메인 엔티티
│   ├── repositories/        # 리포지토리 인터페이스
│   └── usecases/            # 유스케이스
│
└── presentation/            # 프레젠테이션 계층 (MVVM)
    ├── pages/               # 페이지
    │   ├── home/            # 홈 페이지
    │   │   ├── models/      # 뷰 모델
    │   │   ├── viewmodels/  # 뷰모델
    │   │   └── views/       # 뷰
    │   ├── login/           # 로그인 페이지
    │   └── ...
    └── widgets/             # 공통 위젯
```

## 아키텍처 패턴

이 프로젝트는 MVVM (Model-View-ViewModel) 아키텍처 패턴을 사용합니다.

### MVVM 구조

1. **Model**
    - 데이터와 비즈니스 로직을 포함
    - 도메인 계층의 엔티티와 유스케이스를 사용
    - 데이터 계층의 리포지토리를 통해 데이터 접근

2. **View**
    - UI 요소를 표시
    - 사용자 입력을 ViewModel에 전달
    - ViewModel의 상태 변화를 감지하여 UI 업데이트

3. **ViewModel**
    - View와 Model 사이의 중재자 역할
    - View의 상태 관리
    - Model의 데이터를 View에 맞게 변환
    - 비즈니스 로직 처리

### 계층별 책임

#### Presentation Layer (MVVM)

- UI 관련 로직
- 사용자 상호작용 처리
- ViewModel을 통한 상태 관리

#### Domain Layer

- 비즈니스 로직
- 엔티티 정의
- 유스케이스 정의
- 리포지토리 인터페이스 정의

#### Data Layer

- 데이터 소스 구현
- 리포지토리 구현
- API 통신
- 로컬 저장소 관리

## 의존성 주입

- Provider를 사용하여 의존성 주입
- 각 계층의 의존성을 명확하게 분리
- 테스트 용이성 확보

## 상태 관리

- Provider를 사용하여 상태 관리
- ViewModel에서 상태 변경 처리
- View에서 상태 변화 감지 및 UI 업데이트

## 라우팅

- GoRouter를 사용하여 라우팅 관리
- 중앙 집중식 라우팅 처리
- 딥링크 지원