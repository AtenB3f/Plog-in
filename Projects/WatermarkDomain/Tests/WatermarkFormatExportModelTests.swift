//
//  WatermarkFormatExportModelTests.swift
//  WatermarkDomainTests
//

import CoreGraphics
import Testing
import PlatformCore
@testable import WatermarkDomain

private func expectEqual(_ a: CGSize, _ b: CGSize, sourceLocation: SourceLocation = #_sourceLocation) {
    #expect(abs(a.width - b.width) < 0.001, sourceLocation: sourceLocation)
    #expect(abs(a.height - b.height) < 0.001, sourceLocation: sourceLocation)
}

/// 워터마크 이미지를 저장할 때 실제 px 사이즈를 계산하는 테스트
@Suite("WatermarkFormat.makeExportModel — WatermarkExportType.auto")
struct MakeExportModelAutoTests {
    let format = WatermarkFormat()

    @Test("WatarmarkArrayType.none은 첫 이미지 크기를 반환")
    func none() {
        let images = [
            PImage.testFixture(width: 800, height: 600)
        ]
        let array = WatermarkArrayModel(type: .none)
        let export = format.makeExportModel(origins: images, array: array)
        expectEqual(export.getSize(), CGSize(width: 800, height: 600))
    }

    @Test(
        "WatarmarkArrayType.horizontal — 최대값(1500) 이하/초과",
        arguments: [
            (CGSize(width: 400, height: 300), 3, CGSize(width: 1200, height: 300)), // 합계 1200 → 미만
            (CGSize(width: 600, height: 300), 3, CGSize(width: 1500, height: 250))  // 합계 1800 → 초과
        ]
    )
    func horizontal(imageSize: CGSize, columns: Int, expected: CGSize) {
        let images = [PImage.testFixture(width: imageSize.width, height: imageSize.height)]
        let array = WatermarkArrayModel(type: .horizontal, rows: 1, columns: columns)
        let export = format.makeExportModel(origins: images, array: array)
        expectEqual(export.getSize(), expected)
    }

    @Test(
        "WatarmarkArrayType.vertical — 최대값(1500) 이하/초과",
        arguments: [
            (CGSize(width: 300, height: 300), 3, CGSize(width: 300, height: 900)),  // 합계 900 → 미만
            (CGSize(width: 300, height: 1000), 3, CGSize(width: 150, height: 1500)) // 합계 3000 → 초과
        ]
    )
    func vertical(imageSize: CGSize, rows: Int, expected: CGSize) {
        let images = [PImage.testFixture(width: imageSize.width, height: imageSize.height)]
        let array = WatermarkArrayModel(type: .vertical, rows: rows, columns: 1)
        let export = format.makeExportModel(origins: images, array: array)
        expectEqual(export.getSize(), expected)
    }

    @Test(
        "WatarmarkArrayType.grid — 가로형/세로형 최대값(1500) 이하/초과",
        arguments: [
            (CGSize(width: 100, height: 50), 1, 2, CGSize(width: 200, height: 50)),     // 가로형, 이하
            (CGSize(width: 1000, height: 100), 1, 2, CGSize(width: 1500, height: 75)),  // 가로형, 초과
            (CGSize(width: 50, height: 100), 2, 1, CGSize(width: 50, height: 200)),     // 세로형, 이하
            (CGSize(width: 1000, height: 800), 2, 2, CGSize(width: 1500, height: 1200)), // 가로형, 초과
            (CGSize(width: 800, height: 1000), 2, 2, CGSize(width: 1200, height: 1500))  // 세로형, 초과
        ]
    )
    func grid(imageSize: CGSize, rows: Int, columns: Int, expected: CGSize) {
        let images = [PImage.testFixture(width: imageSize.width, height: imageSize.height)]
        let array = WatermarkArrayModel(type: .grid, rows: rows, columns: columns)
        let export = format.makeExportModel(origins: images, array: array)
        expectEqual(export.getSize(), expected)
    }

    @Test("WatarmarkArrayType.grid — origins.first가 아니라 가장 세로가 긴 이미지 기준으로 셀 비율 결정, 최대값 이하")
    func gridWithMixedRatioImagesUnderMax() {
        let images = [
            PImage.testFixture(width: 100, height: 100), // origins.first, 정사각형
            PImage.testFixture(width: 100, height: 200)  // 더 세로로 긴 이미지
        ]
        let array = WatermarkArrayModel(type: .grid, rows: 1, columns: 2)
        let export = format.makeExportModel(origins: images, array: array)
        // origins.first(100x100)만 봤다면 (200, 100)이 되지만, 더 세로로 긴 두 번째 이미지 기준으로 (200, 200)이어야 함
        expectEqual(export.getSize(), CGSize(width: 200, height: 200))
    }

    @Test("WatarmarkArrayType.grid — 가장 세로가 긴 이미지 기준 셀 비율 + 최대값(1500) 초과")
    func gridWithMixedRatioImagesOverMax() {
        let images = [
            PImage.testFixture(width: 800, height: 800),  // origins.first, 정사각형
            PImage.testFixture(width: 800, height: 1600)  // 더 세로로 긴 이미지
        ]
        let array = WatermarkArrayModel(type: .grid, rows: 1, columns: 1)
        let export = format.makeExportModel(origins: images, array: array)
        expectEqual(export.getSize(), CGSize(width: 750, height: 1500))
    }
}

@Suite("WatermarkFormat.makeExportModel — WatermarkExportType.multiple")
struct MakeExportModelMultipleTests {
    let format = WatermarkFormat()

    @Test(".none - 첫 번째 이미지 크기에 multiple을 곱한 값")
    func none() {
        let images = [PImage.testFixture(width: 400, height: 300)]
        let array = WatermarkArrayModel(type: .none)
        let export = format.makeExportModel(origins: images, array: array, multiple: 2)
        expectEqual(export.getSize(), CGSize(width: 800, height: 600))
    }

    @Test(
        ".horizontal — watermark image 크기에 multiple을 곱한 값. 가로값 최대 3000px",
        arguments: [
            (CGSize(width: 1000, height: 600), 2, 2, CGSize(width: 3000, height: 900)),
            (CGSize(width: 600, height: 1000), 2, 2, CGSize(width: 2400, height: 2000))
        ]
    )
    func horizontal(imageSize: CGSize, columns: Int, multiple: CGFloat, expected: CGSize) {
        let images = [PImage.testFixture(width: imageSize.width, height: imageSize.height)]
        let array = WatermarkArrayModel(type: .horizontal, rows: 1, columns: columns)
        let export = format.makeExportModel(origins: images, array: array, multiple: multiple)
        expectEqual(export.getSize(), expected)
    }

    @Test(
        ".vertical — watermark image 크기에 multiple을 곱한 값. 세로값 최대 3000px",
        arguments: [
            (CGSize(width: 1000, height: 600), 2, 2, CGSize(width: 2000, height: 2400)),
            (CGSize(width: 600, height: 1000), 2, 2, CGSize(width: 900, height: 3000))
        ]
    )
    func vertical(imageSize: CGSize, rows: Int, multiple: CGFloat, expected: CGSize) {
        let images = [PImage.testFixture(width: imageSize.width, height: imageSize.height)]
        let array = WatermarkArrayModel(type: .vertical, rows: rows, columns: 1)
        let export = format.makeExportModel(origins: images, array: array, multiple: multiple)
        expectEqual(export.getSize(), expected)
    }

    @Test(
        ".grid — watermark image 크기에 multiple을 곱한 값. 단, 가로,세로 모두 최대 3000px",
        arguments: [
            (CGSize(width: 100, height: 50), 1, 2, 2, CGSize(width: 400, height: 100)),     // 가로형 합계 400 → 미만
            (CGSize(width: 1000, height: 100), 1, 2, 2, CGSize(width: 3000, height: 150)),  // 가로형 합계 4000 → 초과
            (CGSize(width: 100, height: 50), 2, 1, 2, CGSize(width: 200, height: 200)),     // 세로형 합계 200 → 미만
            (CGSize(width: 1000, height: 100), 2, 1, 2, CGSize(width: 2000, height: 400)),  // 가로형 합계 4000 → 초과
            (CGSize(width: 1000, height: 1200), 2, 2, 2, CGSize(width: 2500, height: 3000)) // 세로형 합계 4800 → 초과
        ]
    )
    func grid(imageSize: CGSize, rows: Int, columns: Int, multiple: CGFloat, expected: CGSize) {
        let images = [PImage.testFixture(width: imageSize.width, height: imageSize.height)]
        let array = WatermarkArrayModel(type: .grid, rows: rows, columns: columns)
        let export = format.makeExportModel(origins: images, array: array, multiple: multiple)
        expectEqual(export.getSize(), expected)
    }

    @Test(
        "multiple=1.0은 항상 auto(1500px 캡) 결과와 동일해야 함",
        arguments: [
            (WatermarkArrayModel(type: .horizontal, rows: 1, columns: 2), CGSize(width: 600, height: 300)),
            (WatermarkArrayModel(type: .vertical, rows: 3, columns: 1), CGSize(width: 300, height: 1000)),
            (WatermarkArrayModel(type: .grid, rows: 2, columns: 2), CGSize(width: 1000, height: 1200))
        ]
    )
    func multipleOneEqualsAuto(array: WatermarkArrayModel, imageSize: CGSize) {
        let images = [PImage.testFixture(width: imageSize.width, height: imageSize.height)]
        let autoExport = format.makeExportModel(origins: images, array: array)
        let multipleExport = format.makeExportModel(origins: images, array: array, multiple: 1.0)
        expectEqual(multipleExport.getSize(), autoExport.getSize())
    }

    @Test(".horizontal — columns가 많아 auto 자체가 이미 1500px 캡에 걸려도, multiple=1.0은 auto와 동일해야 함")
    func horizontalManyColumnsMultipleOneMatchesAuto() {
        let images = [PImage.testFixture(width: 800, height: 600)]
        let array = WatermarkArrayModel(type: .horizontal, rows: 1, columns: 10)
        let autoExport = format.makeExportModel(origins: images, array: array)
        let multipleExport = format.makeExportModel(origins: images, array: array, multiple: 1.0)
        // auto 자체도 캡에 걸려야 의미 있는 회귀 테스트가 됨 (예전 공식이면 여기서 3000으로 잘못 나왔음)
        expectEqual(autoExport.getSize(), CGSize(width: 1500, height: 112.5))
        expectEqual(multipleExport.getSize(), autoExport.getSize())
    }

    @Test(".grid — multiple 값에 비례해서 auto 결과가 스케일되어야 함")
    func gridScalesProportionallyWithMultiple() {
        let images = [PImage.testFixture(width: 1000, height: 800)]
        let array = WatermarkArrayModel(type: .grid, rows: 2, columns: 2)
        let autoSize = format.makeExportModel(origins: images, array: array).getSize()
        let multipleExport = format.makeExportModel(origins: images, array: array, multiple: 1.5)
        expectEqual(multipleExport.getSize(), CGSize(width: autoSize.width * 1.5, height: autoSize.height * 1.5))
    }

    @Test(".grid — 2.0을 넘는 레거시 multiple 값이 들어와도 3000px로 안전 클램프되어야 함")
    func gridClampsLegacyMultipleAboveTwo() {
        let images = [PImage.testFixture(width: 1000, height: 800)]
        let array = WatermarkArrayModel(type: .grid, rows: 2, columns: 2)
        let export = format.makeExportModel(origins: images, array: array, multiple: 3.0)
        expectEqual(export.getSize(), CGSize(width: 3000, height: 2400))
    }
}

/// array.type == .none일 때 이미지 각각의 원본 비율을 유지한 채 export 사이즈를 구하는 테스트
@Suite("WatermarkFormat.getExportSize(for:export:)")
struct GetExportSizeTests {
    let format = WatermarkFormat()

    @Test("auto 타입은 이미지 원본 크기를 그대로 반환")
    func auto() {
        let image = PImage.testFixture(width: 400, height: 800)
        let export = WatermarkExportModel(type: .auto, width: 0, height: 0, multiple: 1)
        expectEqual(format.getExportSize(for: image, export: export), CGSize(width: 400, height: 800))
    }

    @Test("multiple 타입은 이미지 원본 크기에 배율을 곱해서 반환")
    func multiple() {
        let image = PImage.testFixture(width: 300, height: 600)
        let export = WatermarkExportModel(type: .multiple, width: 0, height: 0, multiple: 2.5)
        expectEqual(format.getExportSize(for: image, export: export), CGSize(width: 750, height: 1500))
    }

    @Test("이미지마다 원본 비율이 달라도 각자의 비율을 그대로 유지한다 (origins.first 기준으로 통일되지 않음)")
    func perImageAspectRatioPreserved() {
        let images = [
            PImage.testFixture(width: 800, height: 600), // 4:3
            PImage.testFixture(width: 600, height: 800)  // 3:4
        ]
        let export = WatermarkExportModel(type: .auto, width: 0, height: 0, multiple: 1)
        let sizes = images.map { format.getExportSize(for: $0, export: export) }
        expectEqual(sizes[0], CGSize(width: 800, height: 600))
        expectEqual(sizes[1], CGSize(width: 600, height: 800))
    }
}
