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
            (CGSize(width: 1000, height: 800), 2, 2, CGSize(width: 1500, height: 600)), // 가로형, 초과
            (CGSize(width: 800, height: 1000), 2, 2, CGSize(width: 600, height: 1500))  // 세로형, 초과
        ]
    )
    func grid(imageSize: CGSize, rows: Int, columns: Int, expected: CGSize) {
        let images = [PImage.testFixture(width: imageSize.width, height: imageSize.height)]
        let array = WatermarkArrayModel(type: .grid, rows: rows, columns: columns)
        let export = format.makeExportModel(origins: images, array: array)
        expectEqual(export.getSize(), expected)
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
}
