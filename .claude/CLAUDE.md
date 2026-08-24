
# Plog-in

iOS 및 macOS에서 워터마크가 있는 사진 편집 프로젝트
추후 워터마크 사진 편집 뿐만 아니라 일반 사진 편집, 동영상 편집 기능, 유튜브 라이브 편집 기능 추가 예정
딥링크 기능을 통해 워터마크 이미지 생성이 가능하도록 기능 추가 예정

## 🎯 프로젝트 개요

- **목적**: 사용자가 사진에 텍스트 및 이미지 워터마크를 추가하고 편집할 수 있는 기능 제공
- **플랫폼**: iOS, macOS (현재 개발은 iOS 기준으로 개발 중, 추후 macOS 추가 예정) 
- **주요 기능**: 워터마크 편집, 워터마크 편집 프레임 저장

## 📁 프로젝트 구조 
- **프로젝트 관리 도구**: Tusit 4.32.1. mise 2024.11.1 macos-arm64 (4927c37 2024-11-05)를 통해 tuist 특정 버전 설치
- **프로젝트 구성 폴더**: 전체 프로젝트 폴더 구조 - `./Tuist/Config.swift`, 프로젝트 타겟 기본 구조 - `./Tuist/ProjectDescriptionHelpers/Manifest+Shared.swift`
- **프로젝트 생성 방법**: 프로젝트 구성이 변경되었을 경우 `make generate` 명령어를 통해 다시 생성함

## 📦 핵심 모듈
- **API**: 추후 API를 사용할 경우 네트워크 레이어
- **CoreDomain**: 워터마크 사진 및 일반 사진 편집, 동영상 및 유튜브 라이브 편집에서 공통으로 사용되는 비즈니스 로직 
- **Design**: UI 컴포넌트 관련
- **ImageFeature**: 이미지 편집 관련 기능이 있는 페이지 구현 (추후 추가 예정)
- **Persistence**: SwiftData와 같은 Data관련 코드(Entity, Mapper 등)
- **PlatformCore**: iOS와 macOS에서 호환 가능한 타입. typealias관련 코드
- **PlatformExport**: iOS와 macOS에서 사진 및 영상 로드 및 출력 
- **Plogin**: 메인 앱. DIContainer 등 중앙 관리 모듈
- **RenderEngine**: 워터마크 및 이미지 출력 시 UIGraphicsImageRenderer등을 이용한 렌더 기능 구현
- **UISchema**: 페이지 구현을 위한 UI 규칙
- **Utility**: 앱 공통에서 사용하는 기능 (추후 추가 예정)
- **VideoFeature**: 비디오 편집 관련 기능이 있는 페이지 구현 (추후 추가 예정)
- **WatermarkDomain**: 워터마크 생성과 관련된 비즈니스 로직
- **WatermarkFeature**: 워터마크 관련 기능이 있는 페이지 구현
- **WatermarkPreviewSupport**: UIGraphicsImageRenderer로 생성되는 워터마크 이미지 결과물과 SwiftUI를 통해 화면에 보여지는 이미지 결과물의 차이를 확인하기 위한 헬퍼

## 🔗 모듈 의존성 규칙
- 순환참조 금지
- Feature 모듈은 다른 Feature 모듈을 직접 참조 금지
- Persistence는 Domain 레이어에서만 접근, Feature에서 직접 접근 금지 (단, Plogin은 DIContainer 구성을 위해 예외적으로 직접 참조)
- **Plogin**: PlatformCore, WatermarkFeature, WatermarkDomain, VideoFeature, ImageFeature, Persistence, Design, RenderEngine, YouTubeKit 참조(역방향 금지)
- **CoreDomain**: 앱 전체에서 사용하는 Domain영역이기에 PlatformCore를 제외한 참조가 있으면 안됨
- **WatermarkDomain**: CoreDomain와 PlatformCore를 제외한 참조가 있으면 안됨
- **PlatformCore**: 최하위 모듈. 다른 모듈 참조 금지
- **UISchema**: PlatformCore를 제외한 참조가 있으면 안됨
- **Design**: PlatformCore, UISchema를 제외한 참조가 있으면 안됨
- **PlatformExport**: PlatformCore, CoreDomain을 제외한 참조가 있으면 안됨
- **Persistence**: ~Domain을 제외한 참조가 있으면 안됨 (Domain 모델을 Entity로 매핑하기 위한 참조)
- **RenderEngine**: ~Domain, PlatformCore, PlatformExport를 제외한 참조가 있으면 안됨


## 🛠️ 기술 스택

| 항목 | 내용 |
|------|------|
| 언어 | Swift |
| UI 프레임워크 | SwiftUI |
| 프레임워크 | YouTubeKit |
| 최소 OS 버전 | iOS 17+, macOS 14+ |
| 의존성 | SPM (Swift Package Manager) |
| 아키텍처 | Modular Architecture, Clean Architecture |
| 디자인패턴 | MVVM |
| CI/CD | Github Actions |

## 🚀 빌드 및 실행

### 프로젝트 구성
```bash
make generate```

## ⚠️ 알려진 이슈 & 해결 팁

### 자주 겪는 문제
- **빌드 실패**: `tuist clean` 후 `make generate` 실행


## 현재 진행중인 작업/및 방향성
WatermarkFeature에서 편집모드 관련 리팩토링을 진행 중. 브랜치는 refactor/watermark_edit에서 작업 중.


## 테스트 전략
테스트 전략에 대한 조언이 필요함. 대화를 이어나가며 현재 진행중인 작업에서 테스트를 하기 적합한 사례가 있다면 추천할 것.


## 브랜치 컨벤션
- **dev**: 기본 개발 브랜치
- **main**: 배포 브랜치
- **feature/~**: 새로운 기능 추가 시
- **bugfix/~**: 오류 수정 시
- **refactor/~**: 리팩토링 시


## 커밋 메시지 컨벤션
- 커밋 메시지는 함수명, 변수명, 모듈명 등 명칭을 제외하고 한글로 작성할 것
- `feat`, `fix` 등 제목에서 크게 어떤 것을 추가하였는지 위주로 설명 후, 개행한 뒤 '-'를 이용해 상세한 추가 설명
- 댠순하게 바꾼게 아니라 정책 변경이나 트러블 슈팅으로 인한 수정이라면 함께 설명할 것.
- Scope는 큰 카테고리로 분류하여 넣을 것 (Watermark, Video, Image, Persistence, Domain, RenderEngine, Platform, Design) 
- `feat(Scope)`: 새로운 기능 추가 설명
- `fix(Scope)`: 오류 수정 설명. 어떤 증상이 발생한게 있다면 해당 증상 설명할 것.
- `chore(Scope)`: tuist관련 설정 및 빌드설정, CI/CD 변경 설명
- `refactor(Scope)`: 코드 리팩토링
