//
//  WatermarkFormatStickerPositionTests.swift
//  WatermarkDomainTests
//

import CoreGraphics
import Testing
@testable import WatermarkDomain

@Suite("WatermarkFormat.limitStickerPosition")
struct LimitStickerPositionTests {
    let format = WatermarkFormat()
    let imageSize = CGSize(width: 800, height: 600)

    @Test("제한 범위 안의 위치는 그대로 통과")
    func insideLimitPassesThrough() {
        let position = CGPoint(x: 120, y: -250)

        let result = format.limitStickerPosition(position, watermarkImageSize: imageSize)

        #expect(result == position)
    }

    @Test(
        "이미지 2배 영역을 벗어나면 경계값으로 잘림",
        arguments: [
            (CGPoint(x: 1200, y: 0), CGPoint(x: 800, y: 0)),
            (CGPoint(x: -1200, y: 0), CGPoint(x: -800, y: 0)),
            (CGPoint(x: 0, y: 900), CGPoint(x: 0, y: 600)),
            (CGPoint(x: 0, y: -900), CGPoint(x: 0, y: -600)),
            (CGPoint(x: 5000, y: -5000), CGPoint(x: 800, y: -600))
        ]
    )
    func outsideLimitIsClamped(position: CGPoint, expected: CGPoint) {
        let result = format.limitStickerPosition(position, watermarkImageSize: imageSize)

        #expect(result == expected)
    }

    @Test("경계값 자체는 잘리지 않음")
    func boundaryIsKept() {
        let position = CGPoint(x: 800, y: -600)

        let result = format.limitStickerPosition(position, watermarkImageSize: imageSize)

        #expect(result == position)
    }

    @Test("한 축만 벗어나면 그 축만 잘림")
    func onlyExceedingAxisIsClamped() {
        let position = CGPoint(x: 1000, y: 100)

        let result = format.limitStickerPosition(position, watermarkImageSize: imageSize)

        #expect(result == CGPoint(x: 800, y: 100))
    }
}
