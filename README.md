<img src="Projects/Plogin/Resources/Asset.xcassets/AppIcon.appiconset/App_Icon.png" width="120" alt="Plogin 앱 아이콘" />

# Plogin

[App Store 다운로드](https://apps.apple.com/app/id6772023012)

> SwiftUI 기반 워터마크 제작 iOS 앱

클린 아키텍처와 모듈러 아키텍처를 이전 프로젝트들보다 꼼꼼하게 적용해보기 위해 시작한 개인 프로젝트입니다.
추후 이미지·영상 편집 기능으로 확장 계획이 있기에 기능이 추가되어도 기존 코드가 흔들리지
않는 구조를 목표로 의존성 분리를 최대한 명시적으로 가져갔습니다.


<br>

## 목차
- [기술 스택](#기술-스택)
- [구현 기능](#구현-기능)
- [아키텍처](#아키텍처)
- [의존성 방향](#의존성-방향)
- [렌더링 전략](#렌더링-전략)
- [로드맵](#로드맵)
- [실행 방법](#실행-방법)
- [테스트 전략](#테스트-전략)
- [AI 활용 방식](#ai-활용-방식)
- [회고](#회고)

<br>

## 기술 스택

| 분류 | 기술 |
|---|---|
| Language | Swift |
| UI | SwiftUI |
| 반응형 | Combine |
| 로컬 저장소 | SwiftData |
| 이미지 처리 | Core Graphics |
| 미디어 | PhotosUI |
| 모니터링 | Firebase Crashlytics |
| 프로젝트 관리 | Tuist, SwiftLint |

<br>

## 구현 기능

| 기능 | 설명 |
|---|---|
| **워터마크 편집** | 텍스트·스티커·프레임·배열·출력 크기 메뉴 |
| **실시간 프리뷰** | 편집 중인 워터마크를 SwiftUI로 즉시 렌더링 |
| **워터마크 저장** | SwiftData 기반 로컬 저장 |
| **사진 선택** | PhotosUI 기반 AssetPicker |
| **내비게이션·팝업** | 홈/탭 내비게이션, 공통 팝업 시스템 |
| **홈 탭 · 커스텀 프레임** | 홈 탭에서 커스텀 프레임 편집으로 연결되는 플로우, 프레임 썸네일 생성 |
| **크래시 모니터링** | Firebase Crashlytics를 CoreDomain의 `CrashReport` 프로토콜로 추상화하여 연동 |

<br>

## 아키텍처

Tuist 워크스페이스를 계층별로 분리하고, 의존성 방향이 모듈 경계를 통해 지켜지도록 설계했습니다.

| 계층 | 모듈 | 역할 |
|---|---|---|
| App | Plogin | DIContainer 조립, Tab/Navigation Coordinator, Firebase Crashlytics 구현체 |
| Feature | WatermarkFeature | 워터마크 편집 화면·메뉴·팝업 |
| Feature | ImageFeature, VideoFeature | 확장 예정 |
| Domain | WatermarkDomain | Model, Repository 프로토콜, Usecase |
| Domain | CoreDomain | 앱 전역에서 쓰는 Domain 추상화 — `CrashReport` 프로토콜, `ImageExportRepository` 등 |
| Data | Persistence | SwiftData Entity, DataStore, Mapper |
| Platform | PlatformCore | iOS/macOS typealias 추상화 |
| Platform | PlatformExport | PhotosUI 래핑 |
| Render | RenderEngine | Core Graphics 이미지 합성 |
| UI | Design | SwiftUI 디자인 UI 컴포넌트 |
| UI | UISchema | NavigationCoordinator/PopupCoordinator 프로토콜, 레이아웃 스키마 |
| 검증 지원 | WatermarkPreviewSupport | SwiftUI Preview 결과물과 실제 렌더(Core Graphics) 결과물의 차이를 확인하기 위한 헬퍼 |
| - | API, Utility | 모듈 경계만 분리해둔 상태, 확장 예정 |



## 의존성 방향
**DI와 Composition Root**

Repository 프로토콜은 **Domain 모듈**에 정의되어 있고, SwiftData 구현체는
**Persistence 모듈**에 있습니다. <br> 
의존 방향은 Persistence → Domain 단방향으로 Usecase에서 구현체의 코드를 알 수 없도록 하였습니다.

```swift
// WatermarkDomain — Repository 프로토콜 (Domain)
public protocol WatermarkRepository {
    func getWatermarks() -> [WatermarkModel]
    func setWatermark(_ watermark: WatermarkModel)
    func removeWatermark(_ id: UUID)
    func getWatermarks(type: WatermarkFrameType) -> [WatermarkModel]
}

// WatermarkDomain — Usecase는 프로토콜에만 의존
public class WatermarkUsecase {
    let wordDataStore: any WatermarkWordRepository
    let watermarkDataStore: any WatermarkRepository
    ...
}

// Persistence — SwiftData 구현체가 Domain 프로토콜을 채택
extension WatermarkDataStore: WatermarkWordRepository { ... }
```

객체 생성은 앱 계층 DIContainer의 팩토리 메서드로 중앙화되어 있습니다.
View·ViewModel·Usecase·Coordinator를 DIContainer가 생성·주입합니다.

저장 방식을 SwiftData에서 다른 것으로 교체하여도 Domain은 변경되지 않고
DIContainer 한 곳으로만 수정하면 변경 가능하도록 개발되었습니다.
클린 아키텍처의 의존성 규칙(바깥 → 안쪽)을 **Tuist 모듈 경계와 Composition Root 구조로 컴파일 타임에 강제**하도록 설계하였습니다.

같은 패턴을 Firebase Crashlytics 도입 시에도 그대로 재사용했습니다. `CoreDomain`에 `CrashReport`
프로토콜을 정의하고, `Plogin` 앱 계층의 `FirebaseCrashReportImpl`이 이를 구현합니다. Domain·Feature
쪽 코드는 `CrashReport` 프로토콜만 알고 있어서, 이후 Crashlytics를 다른 크래시 리포팅 도구로 교체하거나
제거하더라도 `Plogin` 모듈의 구현체만 바꾸면 되는 구조입니다.

<br>

## 렌더링 전략

**초기 구현**: 유저가 UI에서 컬러·여백 등을 조정할 때마다 Core Graphics 이미지 합성방식으로 이미지를 생성하여 프리뷰로 사용했습니다.

**문제**: 슬라이더를 움직이는 UI를 조정할 때마다 이미지를 생성하다 보니 메모리 사용량이 커지고 딜레이가 발생했습니다.

**개선 방향**: 편집 중 프리뷰는 **SwiftUI 뷰로 즉각 렌더링**하고, Core Graphics
이미지 생성은 **실제 내보내기 시점에만** 수행<br> 
같은 비즈니스 로직과 모델을 `WatermarkDomain`(`WatermarkDomain`,`WatermarkModel`)에 구현하여 `RenderEngine`과 `WatermarkFeature`에서 동일한 규칙을 적용하여 SwiftUI 프리뷰와 Core Graphics의 결과물이 동일하게 나타나도록 하였습니다.

<br>

## 로드맵
워터마크 생성 기능이 완료된 후 이미지 편집, 비디오 편집 기능을 추가히기 위하여 모듈로 사전에 분리하게 되었습니다. <br>
`ImageFeature`, `VideoFeature`, `API`, `Utility`의 경우 아직 모듈 경계만 분리되어 있고 미구현 상태입니다.

1. **리팩토링 (완료)** — 프리뷰/내보내기 시 동일한 비즈니스 로직을 적용하고 렌더링할 수 있도록 리팩토링
2. **테스트 및 확인 방식 추가 (완료)** — `WatermarkPreviewSupport` 모듈에 샘플 이미지를 포함시켜, SwiftUI Preview에서 워터마크 적용 결과를 바로 확인할 수 있도록 함
3. **App Store 배포 및 CI/CD 도입 (진행 중)** — 앱 암호화 관련 Info.plist 대응, 사진 접근 권한 안내 문구 정비, Fastlane을 이용한 인증서 관리 및 배포 파이프라인 구성 진행 중
4. **이미지 편집 (ImageFeature, ImageDomain)** — `ImageDomain`에 ImageModel과 Core Graphics을 사용하여 이미지를 편집할 수 있는 비즈니스 로직 추가. 이후 `RenderEngine`에서 이미지를 저장할 수 있는 기능 추가 예정
5. **영상 편집 (VideoFeature, VideoDomain)** — `VideoDomain`에 VideoModel과 Core Graphics을 사용하여 영상을 편집할 수 있는 비즈니스 로직 추가. 이후 `RenderEngine`에서 비디오를 저장할 수 있는 기능 추가 예정
6. **YouTube 라이브 편집 (추후 추가 예정)** — `YoutubeManager` 등 매니저 코드는 준비되어 있으나, 아직 사용자에게 보여지는 화면은 없는 상태
7. **macOS 확장** — 동일한 기능을 macOS에서도 동작할 수 있도록 `RenderEngine`의 출력 방식 구현과 macOS용 Feature를 구현 예정

<br>

## 실행 방법

[mise](https://mise.jdx.dev)로 Tuist 버전(v4.32.1)을 설치합니다.

```bash
# 1. Tuist 설치
mise install

# 2. 워크스페이스 생성
make generate

# 3. 실행
open Plogin.xcworkspace
```

<br>

## 테스트 전략

**유닛 테스트 — WatermarkDomain, RenderEngine**

Swift Testing 프레임워크(`import Testing`, `@Suite`/`@Test`)로 작성했고, `Tuist/ProjectDescriptionHelpers/Manifest+Shared.swift`의 `unitTestTarget(for:)` 헬퍼로 모듈별 Test 타겟을 표준화했습니다.

- `WatermarkDomain`: `WatermarkFormat`의 순수 계산 로직 — 배열/셀 크기 계산(`makeArrayModel`, `getCellRatio`, `getGridSize`), 문구 표기 형식(`getDisplayText`), 내보내기 시 grid 셀 비율 결정 규칙(`makeExportModel`), 스티커 위치 clamp(`limitStickerPosition`), 배열 타입별 이미지 크기 계산(`getWatermarkImageSize`) 검증
- `RenderEngine`: `WatermarkEditor.generateThumbnail`의 크기 계산과 엣지 케이스(`origins`가 비어있어도 크래시 없이 기본값을 반환하는지) 검증

두 모듈 모두 SwiftUI·SwiftData에 의존하지 않는 순수 함수 위주로 테스트를 작성하였습니다.


**WatermarkPreviewSupport — SwiftUI Preview 기반 시각 검증**

`WatermarkPreviewSupport`는 워터마크 관련 모듈을 의존하여 DEBUG 전용 목업  모듈입니다. `#Preview` 블록이 이 목업을 주입받아, 실제 SwiftData·PhotosUI 없이도 Xcode Canvas에서 워터마크 편집 화면을 곧바로 렌더링해 확인할 수 있습니다. 유닛 테스트가 커버하기 어려운 실제로 보이는 결과물을 빌드 없이 빠르게 확인할 수 있습니다.

<br>

## AI 활용 방식

이 프로젝트는 Claude Code를 활용하여 버그의 근본 원인을 분석하고
아키텍처 규칙과의 일관성을 검증하는 프로그래밍 도구로 활용했습니다.

**근본 원인 분석 기반 디버깅**: 어떠한 이슈를 수정하기 위해 "증상 → 원인 분석 → 코드 위치 → 수정안 → 후속 체크리스트" 순서로 진행했습니다. 예를 들어 두 화면이 동시에 구독하면서 팝업이 안 닫히던 문제, SwiftData 엔티티에 unique 제약이 없어 같은 프레임을 재저장할 때마다 중복 row가 쌓이던 문제 등을 표면적인 증상이 아니라 구조적인 원인까지 추적해서 해결했습니다.

**아키텍처 규칙 검토**: `.claude/CLAUDE.md`에 아키텍처 규칙과 관련된 룰을 기재하여 클린 아키텍처를 유지할 수 있게 서포트하도록 하였습니다. 리팩토링을 하며 프로젝트 분석을 통해 클린아키텍처 관점에서 보완하면 좋을 부분들을 추천받고 검토 후 적용하였습니다.

**리팩토링 검토 및 문제점 발견**: 기능 추가나 이슈를 수정하며 예상되는 크고 작은 문제점과 구조적 문제점들을 `./claude/TODO.md`에 기재하여 운영하며 수정해야하는 부분을 체크리스트로 관리하였습니다.

**격리된 작업 흐름**: 별도 워크트리를 만들어 특정 이슈를 메인 작업 흐름과 분리해서 진행하였습니다.

<br>

## 회고
처음 시작은 가볍게 만들어보고 싶은 기능을 구현하고자 하였으나 개발하며 Clean Architecture나 Modular Architecture를 공부하고 적용하는 것으로 목표를 바꾸게 되었습니다.
그간 진행했던 다른 프로젝트와 현업에서 Usecase 분리, DTO 분리, 모듈화는 등 Clean Architecture를 일부 적용한 프로젝트는 많지만 Dependency Injection를 적용하여 본적이 없었기에 이번 기회에 DI를 완벽하게 적용하고자 하였습니다. 의존성 관리의 용이를 위해 **Composition Root**를 통해 DIContainer의 팩토리 메서드로 중앙화하는 방식으로 프로젝트의 전체 플로우나 객체 생성 위치를 한 곳으로 몰아 디버깅을 할 시에 빠르게 위치를 찾을 수 있도록 하였습니다.

<br>

Tuist를 통해 모듈러 아키텍처가 적용되어 있었기에 기능 확장 시에 강제로 클린 아키텍처를 적용하도록 되어있어 아키텍처의 통일성을 유지할 수 있게 되었습니다. 또한 버그를 수정할 시 수정 범위가 많이 줄어들어 클린 아키텍처의 이점을 체감할 수 있었습니다.<br>

초기에는 좋은 아키텍처 고민없이 기능 추가만 진행하다보니 수정이 필요하게 되었을 때 큰 어려움을 겪었습니다. 처음에는 이미지를 저장하기 전의 프리뷰 또한 UIGraphicsImageRenderer를 통해 렌더링하도록 하였는데 수치값을 조정하게 될 경우 시간이 오래 걸리며 메모리 문제가 발생하였기에 프리뷰 시에는 SwiftUI로 렌더링 할 수 있도록 목표를 잡았습니다. 하지만 리팩토링을 진행 시 수정해야하는 코드가 매우 많았고 여러 역할이 하나의 클래스에 모여있어 코드 관리가 어렵다고 판단하여 전체적으로 리팩토링을 진행하기로 하였습니다.<br>

클린 아키텍처를 도입하여 의존성 분리, 단일 책임 원칙을 지키도록 하여 테스트가 용이한 아키텍처를 만드는 것이 목표였습니다. 또한 렌더링과 관련된 기획이 변경되었을 때 빠르게 적용이 가능하도록 하였고, 추후 추가할 기능이 많았고 복잡한 기능일 것이라 예상되었기에 아키텍처 설계와 리팩토링을 하는 시간을 길게 잡고 고민하였습니다.


<br>

Composition Root와 의존성 분리를 적용하며 가장 크게 느낀 점은 개발 속도가 느려진다는 것이었습니다. 
이 프로젝트는 개인 프로젝트였기에 전체 리팩토링을 한 번에 진행했지만 실무였다면 먼저 폴더 단위로 분리해 순차적으로 진행하고 모듈화와 Composition Root 적용을 동시에 하지는 않았을 것 같습니다.

<br>
AI를 활용하여 신규 기능을 추가할 경우 어떻게 진행해야할지에 대한 노하우를 쌓았습니다. 워터마크 프레임을 저장할 시 썸네일 이미지를 생성하여 저장하는 기능이 있는데, 해당 기능을 개발하기 위해 기획 문서를 작성하여 큰 수정 없이 약 30분 만에 기능 추가를 완성 하였습니다. AI를 활용하여 생산성을 향상시킬 수 있도록 하였습니다.
