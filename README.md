# COUPLE_BOOK_APP

커플 디데이 어플

lib/feature01/data/local 의 **_data_source.dart
lib/feature01/data/local/entities 의 **_entity.dart

lib/feature01/data/services 의 **_service.dart

lib/feature01/domain/models 의 **_model.dart
lib/feature01/domain/usecase 의 **_usecase.dart

lib/feature01/presentation/components 의 sign_in_button.dart
lib/feature01/presentation/pages 의 **_page.dart
lib/feature01/presentation/pages/**/widget 의 **_widget.dart
lib/feature01/presentation/viewmodels 의 **_viewmodel.dart / **_state.dart / **_provider.dart / **_controller.dart

lib/feature01/repository 의 **_repository.dart

지금까지 너랑 같이 리팩토링한 디렉토리 구조이자 안에 있는 파일들이야.
혹시 이해가 안 가는 게 있으면 물어봐.
만약 다 이해가 간다면, 구조 변경을 할 게 있을 경우 어떻게 변경하면 좋을지 알려주고,
이대로 가도 된다면 README.md 형식으로 각 디렉토리 내에 있는 클래스 별 역할과 담당에 대해서 설명을 적어줘.

# 📁 feature01 디렉토리 구조 안내 (MVVM + Clean Architecture)

본 프로젝트는 **MVVM 아키텍처**를 기반으로 하며, 각 계층은 관심사의 분리를 통해 역할을 명확히 나눕니다. 아래는 `lib/feature01/` 디렉토리 하위 구조 및 각 파일의 역할에 대한 설명입니다.

---

## 📦 data/local
- 로컬 저장소 (SecureStorage, SharedPreferences 등)에 접근하는 계층입니다.
- `**_data_source.dart`: 로컬에 직접 접근하는 클래스 (싱글톤 또는 인스턴스)
- 예: `auth_local_data_source.dart`

### ▶ entities
- 저장소와 직결되는 **순수 데이터 구조체**입니다 (Json 기반 DTO와 달리 앱 내 모델)
- `**_entity.dart`: 로컬 저장/읽기용 모델

---

## 📦 data/services
- 디바이스 기능 및 Flutter 플랫폼 관련된 비즈니스 로직을 처리합니다.
- 예: 이미지 압축, 로컬 이미지 저장, 위치 추적 등
- `**_service.dart`: 플랫폼 의존적 기능 담당

---

## 📦 domain/models
- presentation에서 사용하는 **UI 중심 모델** 정의
- entity와 달리 presentation에서 **상태 관리에 사용될 모델**입니다.
- 예: `auth_model.dart`

---

## 📦 domain/usecase
- 하나의 특정 기능 단위로 비즈니스 로직을 캡슐화한 계층
- repository와 viewmodel 사이에서 중간 추상화 레이어
- `**_usecase.dart`: 단일 책임 원칙을 따르는 유스케이스 클래스
- 예: `login_usecase.dart`

---

## 📦 repository
- 여러 데이터소스를 조합하여 도메인 모델을 반환하는 계층
- 주로 API + Local DataSource 조합
- `**_repository.dart`: 도메인에 가까운 통합 저장소
- 예: `auth_repository.dart`

---

## 📦 presentation
### ▶ components
- 재사용 가능한 **UI 컴포넌트**
- 예: `sign_in_button.dart`

### ▶ pages
- 화면 단위 구성
- `**_page.dart`: Scaffold 기반 페이지 구성 파일

#### 📁 pages/**/widget
- 특정 페이지 내부에서만 사용하는 위젯 구성
- `**_widget.dart`: 홈, 설정, 로그인 등 화면 내부 UI 단위 분리

---

## 📦 viewmodels
### ▶ `**_state.dart`
- 화면 상태를 정의하는 클래스
- 예: `AuthState`, `SettingState`

### ▶ `**_viewmodel.dart`
- 상태를 제어하는 StateNotifier
- 외부 유스케이스를 호출하거나 로직 처리 후 상태 갱신

### ▶ `**_provider.dart`
- ViewModel이나 Service를 외부에서 사용할 수 있도록 provider로 선언

### ▶ `**_controller.dart`
- context 기반 처리 (ex. LogoutController처럼 context가 꼭 필요한 UI 처리를 위한 중간 계층)

---

## ✅ 전체 흐름 예시 (로그인 기능)
```
presentation/pages/login_page.dart
    ↓ (사용자 입력 및 버튼 클릭)
presentation/viewmodels/auth_viewmodel.dart
    ↓
domain/usecase/login_usecase.dart
    ↓
repository/auth_repository.dart
    ↓
data/local/auth_local_data_source.dart
    ↓
secure_storage 또는 shared_preferences에 저장
```

---

## ✅ 현재 구조 피드백
현재 디렉토리 구조는 **MVVM + Clean Architecture를 충실히 따르고 있으며** 다음과 같은 장점이 있습니다:

- 관심사 분리가 잘 되어 있음 (UI / 상태 / 데이터소스 / 유스케이스)
- 테스트 용이성 (ViewModel과 UseCase 테스트 가능)
- 유지보수/확장성 뛰어남 (기능 단위로 확장 용이)

---

## ✍️ 향후 추가 고려사항
- domain/entities vs domain/models 구조 분리 (현재는 model만으로 충분)
- feature01 분리 완료 시 `lib/` 최상위로 전환 계획 유지
- 각 계층별 **README.md** 또는 문서화가 팀원 onboarding에 효과적
