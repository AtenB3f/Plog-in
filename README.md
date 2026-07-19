# Plogin

> SwiftUI 기반 워터마크 제작 iOS 앱

클린 아키텍처를 이전 프로젝트들보다 꼼꼼하게 적용해보기 위해 시작한 개인 프로젝트입니다.
추후 이미지·영상 편집 기능으로 확장할 계획이라, 기능이 추가되어도 기존 코드가 흔들리지
않는 구조를 목표로 의존성 분리를 최대한 명시적으로 가져갔습니다.


<br>

## 목차
- [기술 스택](#기술-스택)
- [현재 구현된 기능](#현재-구현된-기능)
- [아키텍처](#아키텍처)
- [의존성 방향](#의존성-방향)
- [렌더링 전략](#렌더링-전략)
- [로드맵](#로드맵)
- [실행 방법](#실행-방법)
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
| 미디어 | PhotosUI, YouTubeKit |
| 프로젝트 관리 | Tuist, SwiftLint |

<br>

## 현재 구현된 기능

| 기능 | 설명 |
|---|---|
| 🖋️ **워터마크 편집** | 텍스트·스티커·프레임·배열·출력 크기 메뉴 |
| 👁️ **실시간 프리뷰** | 편집 중인 워터마크를 SwiftUI로 즉시 렌더링 |
| 💾 **워터마크 저장** | SwiftData 기반 로컬 저장 |
| 🖼️ **사진 선택** | PhotosUI 기반 AssetPicker |
| 🧭 **내비게이션·팝업** | 홈/탭 내비게이션, 공통 팝업 시스템 |

<br>

## 아키텍처

Tuist 워크스페이스를 계층별로 분리하고, 의존성 방향이 모듈 경계를 통해 지켜지도록 설계했습니다.

| 계층 | 모듈 | 역할 |
|---|---|---|
| App | Plogin | DIContainer 조립, Tab/Navigation Coordinator |
| Feature | WatermarkFeature | 워터마크 편집 화면·메뉴·팝업 |
| Feature | ImageFeature, VideoFeature | 확장 예정 |
| Domain | WatermarkDomain | Model, Repository 프로토콜, Usecase |
| Domain | CoreDomain | 확장 예정 |
| Data | Persistence | SwiftData Entity, DataStore, Mapper |
| Platform | PlatformCore | iOS/macOS typealias 추상화 |
| Platform | PlatformExport | PhotosUI 래핑 |
| Render | RenderEngine | Core Graphics 이미지 합성 |
| UI | Design | SwiftUI 디자인 UI 컴포넌트 |
| UI | UISchema | NavigationCoordinator/PopupCoordinator 프로토콜, 레이아웃 스키마 |



## **의존성 방향**
### DI와 Composition Root

Repository 프로토콜은 **Domain 모듈**에 정의되어 있고, SwiftData 구현체는
**Persistence 모듈**에 있습니다. <br> 
의존 방향은 Persistence → Domain 단방향이라, Usecase는
`any WatermarkRepository`만 알 뿐 저장 기술이 SwiftData라는 사실을 전혀 모릅니다.

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

<br>

## 렌더링 전략

**초기 구현**: 유저가 UI에서 컬러·여백 등을 조정할 때마다 Core Graphics 이미지 합성방식으로 이미지를 생성하여 프리뷰로 사용했습니다.

**문제**: 조정할 때마다 이미지를 생성하다 보니 메모리 사용량이 커지고 딜레이가 발생했습니다.

**개선 방향**: 편집 중 프리뷰는 **SwiftUI 뷰로 즉각 렌더링**하고, Core Graphics
이미지 생성은 **실제 내보내기 시점에만** 수행하도록 리팩토링하고 있습니다.<br> 
같은 비즈니스 로직과 모델을 `WatermarkDomain`(`WatermarkDomain`,`WatermarkModel`)에 구현하여 `RenderEngine`과 `WatermarkFeature`에서 동일한 규칙을 적용하여 SwiftUI 프리뷰와 Core Graphics의 결과물이 동일하게 나타나도록 하였습니다.

<br>

## 로드맵
워터마크 생성 기능이 완료된 후 이미지 편집, 비디오 편집 기능을 추가히기 위하여 모듈로 사전에 분리하게 되었습니다. <br>
`ImageFeature`, `VideoFeature`, `CoreDomain`, `API`, `PlatformCore`의 경우 모듈로만 구분되어 있고 미구현 상태입니다.

1. **리팩토링 완료** — 프리뷰/내보내기 시 동일한 비즈니스 로직을 적용하고 렌더링할 수 있도록 리팩토링
2. **테스트 및 확인 방식 추가** - 프로젝트 내에 샘플 이미지를 
포함시켜 SwiftUI Preview에서 워터마크 적용 결과를 바로 확인할 수 있도록 테스트 전략 추가 예정
3. **이미지 편집 (ImageFeature, ImageDomain)** — `ImageDomain`에 ImageModel과 Core Graphics을 사용하여 이미지를 편집할 수 있는 비즈니스 로직 추가. 이후 `RenderEngine`에서 이미지를 저장할 수 있는 기능 추가 예정
4. **영상 편집 (VideoFeature, VideoDomain)** — `VideoDomain`에 VideoModel과 Core Graphics을 사용하여 영상을 편집할 수 있는 비즈니스 로직 추가. 이후 `RenderEngine`에서 비디오를 저장할 수 있는 기능 추가 예정
5. **macOS 확장** — 동일한 기능을 macOS에서도 동작할 수 있도록 `RenderEngine`의 출력 방식 구현과 macOS용 Feature를 구현 예정

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

## 회고

이 프로젝트의 목표는 클린 아키텍처를 깊게 공부하고 실제로 적용해보는 것이었습니다.
Usecase 분리, DTO 분리, 모듈화는 다른 프로젝트에서도 시도해본 적이 있었지만 
**Composition Root**를 적용해본 건 이번이 처음입니다. 객체 생성을 DIContainer의 팩토리 메서드로 중앙화하는 방식을 이번에 처음 배우고 적용해봤습니다.

<br>

아직 기능 확장을 많이 해보지 않아서 클린 아키텍처의 이점을 직접 체감하지는 
못했지만 필요성만큼은 확실히 느꼈습니다.

초기에 작성된 Core Graphics로 렌더링하는 방식이 유저가 UI를 변경하여 설정하는 프리뷰가 딜레이가 생기고 새로 프리뷰를 만들 때마다 메모리 사용량이 커지는 문제를 해결하고자 SwiftUI를 사용해 즉각적으로 프리뷰를 생성하는 리팩토링을 진행 시 Usecase 분리의 필요성을 깊게 체감하였습니다.

SwiftUI 쪽에 필요한 계산과 UIKit 쪽에 필요한 계산이 공통된 부분과 분리되어야 할 부분이 합쳐져있어 코드가 복잡해졌고, "차라리 새로 만드는 게 낫겠다"는 생각이 들 정도였습니다.

계산 결과가 수치상 맞는지뿐 아니라 실제 렌더링 결과와도 일치하는지 
검증하려면 테스트가 필요한데 의존성이 분리되어 있지 않으면 테스트 자체가 
어렵겠다는 판단에 의존성 분리를 진행하게 되었습니다. <br>
(테스트 전략은 아직 적용 전이고, 리팩토링이 끝나는 대로 추가할 계획입니다.)

<br>

Composition Root와 의존성 분리를 적용하며 가장 크게 느낀 점은 개발 속도가 느려진다는 것이었습니다. 
이 프로젝트는 개인 프로젝트였기에 전체 리팩토링을 한 번에 진행했지만 실무였다면 먼저 폴더 단위로 분리해 순차적으로 진행하고 모듈화와 Composition Root 적용을 동시에 하지는 않았을 것 같습니다.

<br>

의존성 분리가 잘 되었기에 다음으로 개선하고 싶은 부분은 테스트 및 확인 과정입니다. 
현재는 빌드 후 기기에 설치하고, 기기 안의 사진을 직접 선택해 워터마크가 적용된 결과를 눈으로 확인하는 방식이라 매번 번거롭습니다. 

프로젝트 내에 샘플 이미지를 포함시켜 SwiftUI Preview에서 워터마크 적용 결과를 바로 확인할 수 있게 하고, 기기별로 렌더링 결과가 어떻게 달라지는지, 그리고 SwiftUI 렌더링과 Core Graphics 렌더링 결과가 서로 일치하는지 한 화면에서 비교할 수 있는 구조를 만들 계획입니다.
