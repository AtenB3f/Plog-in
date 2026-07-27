//
//  WatermarkFormatWatermarkImageSizeTests.swift
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

@Suite("WatermarkFormat.getWatermarkImageSize")
struct GetWatermarkImageSizeTests {
    let format = WatermarkFormat()

    @Test("WatermarkArrayType.none - cell 크기를 그대로 반환")
    func none() {
        let images = [PImage.testFixture(width: 800, height: 600)]
        let array = WatermarkArrayModel(type: .none)
        let cell = format.getCellSize(origins: images, array: array)
        expectEqual(format.getWatermarkImageSize(origins: images, array: array), cell)
    }

    @Test("WatermarkArrayType.horizontal - size: cell width × columns, cell height")
    func horizontal() {
        let images = Array(repeating: PImage.testFixture(width: 400, height: 300), count: 3)
        let array = WatermarkArrayModel(type: .horizontal, rows: 1, columns: 3)
        expectEqual(format.getWatermarkImageSize(origins: images, array: array), CGSize(width: 1200, height: 300))
    }

    @Test("WatermarkArrayType.vertical - size: cell width, cell height × rows")
    func vertical() {
        let images = Array(repeating: PImage.testFixture(width: 300, height: 300), count: 3)
        let array = WatermarkArrayModel(type: .vertical, rows: 3, columns: 1)
        expectEqual(format.getWatermarkImageSize(origins: images, array: array), CGSize(width: 300, height: 900))
    }

    @Test("WatermarkArrayType.grid - size: cell width × columns, cell height × rows")
    func grid() {
        let images = [PImage.testFixture(width: 100, height: 400)]
        let array = WatermarkArrayModel(type: .grid, rows: 2, columns: 1)
        expectEqual(format.getWatermarkImageSize(origins: images, array: array), CGSize(width: 100, height: 800))
    }
}
