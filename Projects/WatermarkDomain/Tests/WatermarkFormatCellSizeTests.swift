//
//  WatermarkFormatCellSizeTests.swift
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

@Suite("WatermarkFormat.getCellRatio")
struct GetCellRatioTests {
    let format = WatermarkFormat()

    @Test("이미지가 없으면 1 반환")
    func emptyOriginsReturnsOne() {
        #expect(format.getCellRatio(origins: []) == 1)
    }

    @Test("단일 이미지는 자신의 가로/세로 비율 반환")
    func singleImage() {
        let images = [PImage.testFixture(width: 400, height: 300)] // w/h = 1.33...
        let ratio = format.getCellRatio(origins: images)
        #expect(abs(ratio - (400/300)) < 0.001)
    }

    @Test("여러 이미지 중 가로/세로 비율이 가장 작은 것 반환")
    func mixedSizesUseTheLeastRatio() {
        let images = [
            PImage.testFixture(width: 400, height: 200), // w/h = 2
            PImage.testFixture(width: 400, height: 300), // w/h = 1.33...
            PImage.testFixture(width: 200, height: 300)  // w/h = 0.66... ← 최소값
        ]
        let ratio = format.getCellRatio(origins: images)
        #expect(abs(ratio - (200/300)) < 0.001)
    }
}

@Suite("WatermarkFormat.getGridSize")
struct GetGridSizeTests {
    let format = WatermarkFormat()

    @Test("이미지가 없으면 .zero 반환")
    func emptyOriginsReturnsZero() {
        expectEqual(format.getGridSize(origins: [], rows: 2, columns: 3), .zero)
    }

    @Test("첫 이미지 기준으로 셀 크기에 rows/columns를 곱한 값 반환")
    func computesFromFirstImage() {
        let images = [PImage.testFixture(width: 400, height: 300)] // cellRatio = 1.33...
        let gridSize = format.getGridSize(origins: images, rows: 2, columns: 3)
        // cellWidth = 400, cellHeight = 400 * 0.75 = 300
        expectEqual(gridSize, CGSize(width: 1200, height: 600))
    }
}

@Suite("WatermarkFormat.getCellSize — WatermarkArrayType.none")
struct GetCellSizeNoneTests {
    let format = WatermarkFormat()

    @Test("이미지가 없으면 .zero를 반환")
    func emptyOriginsReturnsZero() {
        let array = WatermarkArrayModel(type: .none)
        expectEqual(format.getCellSize(origins: [], array: array), .zero)
    }

    @Test(".none은 다른 이미지 크기와 무관하게 첫 이미지 크기를 그대로 반환")
    func returnsFirstImageSizeUnchanged() {
        let images = [
            PImage.testFixture(width: 800, height: 600),
            PImage.testFixture(width: 100, height: 100)
        ]
        let array = WatermarkArrayModel(type: .none)
        expectEqual(format.getCellSize(origins: images, array: array), CGSize(width: 800, height: 600))
    }
}

@Suite("WatermarkFormat.getCellSize — WatermarkArrayType.horizontal")
struct GetCellSizeHorizontalTests {
    let format = WatermarkFormat()

    @Test(
        "1500px 임계값 이하/초과",
        arguments: [
            // (이미지 크기, columns, 기대 cell)
            (CGSize(width: 400, height: 300), 3, CGSize(width: 400, height: 300)),  // 합계 1200 → 원본 그대로
            (CGSize(width: 600, height: 300), 3, CGSize(width: 500, height: 250))   // 합계 1800 → 축소
        ]
    )
    func thresholdBranches(imageSize: CGSize, columns: Int, expected: CGSize) {
        let images = Array(
            repeating: PImage.testFixture(width: imageSize.width, height: imageSize.height),
            count: columns
        )
        let array = WatermarkArrayModel(type: .horizontal, rows: 1, columns: columns)
        expectEqual(format.getCellSize(origins: images, array: array), expected)
    }

    @Test("서로 다른 크기의 이미지들 중 가장 큰 세로/가로 비율 반환")
    func mixedSizesUseWidestRatio() {
        let images = [
            PImage.testFixture(width: 400, height: 300), // h/w = 0.75
            PImage.testFixture(width: 300, height: 300),
            PImage.testFixture(width: 200, height: 300)  // h/w = 1.5 ← 기준
        ]
        let array = WatermarkArrayModel(type: .horizontal, rows: 1, columns: 2)
        expectEqual(format.getCellSize(origins: images, array: array), CGSize(width: 400, height: 600))
    }
}

@Suite("WatermarkFormat.getCellSize — WatermarkArrayType.vertical")
struct GetCellSizeVerticalTests {
    let format = WatermarkFormat()

    @Test(
        "1500px 임계값 이하/초과",
        arguments: [
            (3, CGSize(width: 300, height: 300)),   // 합계 900 → 원본 그대로
            (6, CGSize(width: 250, height: 250))    // 합계 1800 → 축소
        ]
    )
    func thresholdBranches(rows: Int, expected: CGSize) {
        let images = Array(
            repeating: PImage.testFixture(width: 300, height: 300),
            count: rows
        )
        let array = WatermarkArrayModel(type: .vertical, rows: rows, columns: 1)
        expectEqual(format.getCellSize(origins: images, array: array), expected)
    }
}

@Suite("WatermarkFormat.getCellSize — WatermarkArrayType.grid")
struct GetCellSizeGridTests {
    let format = WatermarkFormat()

    @Test(
        "세로형/가로형 총합 × 1500px 임계값 이하/초과 4가지 분기",
        arguments: [
            // (이미지 크기, rows, columns, 기대 cell)
            (CGSize(width: 100, height: 400), 2, 1, CGSize(width: 100, height: 400)),   // 세로형, 이하
            (CGSize(width: 100, height: 1000), 2, 1, CGSize(width: 75, height: 750)),   // 세로형, 초과
            (CGSize(width: 200, height: 100), 2, 2, CGSize(width: 200, height: 100)),   // 가로형, 이하
            (CGSize(width: 1000, height: 100), 1, 2, CGSize(width: 750, height: 75))    // 가로형, 초과
        ]
    )
    func fourBranches(imageSize: CGSize, rows: Int, columns: Int, expected: CGSize) {
        let images = [PImage.testFixture(width: imageSize.width, height: imageSize.height)]
        let array = WatermarkArrayModel(type: .grid, rows: rows, columns: columns)
        expectEqual(format.getCellSize(origins: images, array: array), expected)
    }
}
