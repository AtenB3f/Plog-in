//
//  WatermarkThumbnailEditorTests.swift
//  RenderEngineTests
//

import CoreGraphics
import Testing
import PlatformCore
import WatermarkDomain
@testable import RenderEngine

private let thumbnailSize = CGSize(width: 128, height: 128)

@Suite("WatermarkEditor.generateThumbnail 크기")
struct GenerateThumbnailSizeTests {
    @Test(
        "array type/구성에 관계없이 128x128을 반환",
        arguments: [
            WatermarkArrayModel(type: .none, rows: 1, columns: 1),
            WatermarkArrayModel(type: .horizontal, rows: 1, columns: 3),
            WatermarkArrayModel(type: .vertical, rows: 3, columns: 1),
            WatermarkArrayModel(type: .grid, rows: 2, columns: 2),
            WatermarkArrayModel(type: .grid, rows: 6, columns: 6)
        ]
    )
    func returnsThumbnailSize(array: WatermarkArrayModel) {
        var watermark = WatermarkModel()
        watermark.array = array
        watermark.text.text = "테스트"

        let editor = WatermarkEditor(watermark: watermark, origins: [PImage.testFixture(width: 400, height: 600)])
        let thumbnail = editor.generateThumbnail()

        #expect(thumbnail.size == thumbnailSize)
    }
}

@Suite("WatermarkEditor.generateThumbnail 엣지 케이스")
struct GenerateThumbnailEdgeCaseTests {
    @Test("origins가 비어있어도 크래시 없이 128x128을 반환")
    func emptyOrigins() {
        let editor = WatermarkEditor(watermark: WatermarkModel(), origins: [])
        #expect(editor.generateThumbnail().size == thumbnailSize)
    }

    @Test("텍스트가 비어있어도 크래시 없이 반환")
    func emptyText() {
        var watermark = WatermarkModel()
        watermark.text.text = ""
        let editor = WatermarkEditor(watermark: watermark, origins: [PImage.testFixture(width: 400, height: 600)])
        #expect(editor.generateThumbnail().size == thumbnailSize)
    }

    @Test("스티커가 없어도 크래시 없이 반환")
    func emptyStickers() {
        var watermark = WatermarkModel()
        watermark.stickers = []
        let editor = WatermarkEditor(watermark: watermark, origins: [PImage.testFixture(width: 400, height: 600)])
        #expect(editor.generateThumbnail().size == thumbnailSize)
    }

    @Test("텍스트 rotation 값에 관계없이 크래시 없이 반환", arguments: [0, 45, 90, 180, -30, 360] as [CGFloat])
    func extremeTextRotation(rotation: CGFloat) {
        var watermark = WatermarkModel()
        watermark.text.text = "테스트"
        watermark.text.rotation = rotation
        let editor = WatermarkEditor(watermark: watermark, origins: [PImage.testFixture(width: 400, height: 600)])
        #expect(editor.generateThumbnail().size == thumbnailSize)
    }

    @Test("스티커 scale 극단값에서도 크래시 없이 반환", arguments: [0.001, 1000] as [CGFloat])
    func extremeStickerScale(scale: CGFloat) {
        let sticker = WatermarkStickerModel(
            image: PImage.testFixture(width: 100, height: 100),
            alpha: 1,
            position: .zero,
            rotation: 45,
            scale: scale,
            layer: 0
        )
        var watermark = WatermarkModel()
        watermark.stickers = [sticker]
        let editor = WatermarkEditor(watermark: watermark, origins: [PImage.testFixture(width: 400, height: 600)])
        #expect(editor.generateThumbnail().size == thumbnailSize)
    }

    @Test("grid rows/columns가 0이어도 크래시 없이 반환")
    func invalidGridRowColumn() {
        var watermark = WatermarkModel()
        watermark.array = WatermarkArrayModel(type: .grid, rows: 0, columns: 0)
        let editor = WatermarkEditor(watermark: watermark, origins: [PImage.testFixture(width: 400, height: 600)])
        #expect(editor.generateThumbnail().size == thumbnailSize)
    }

    @Test("스티커 position이 매우 큰 값이어도 크래시 없이 반환")
    func extremeStickerPosition() {
        let sticker = WatermarkStickerModel(
            image: PImage.testFixture(width: 100, height: 100),
            alpha: 1,
            position: CGPoint(x: 100_000, y: -100_000),
            rotation: 0,
            scale: 1,
            layer: 0
        )
        var watermark = WatermarkModel()
        watermark.stickers = [sticker]
        let editor = WatermarkEditor(watermark: watermark, origins: [PImage.testFixture(width: 400, height: 600)])
        #expect(editor.generateThumbnail().size == thumbnailSize)
    }
}

@Suite("WatermarkEditor.generateThumbnail 픽셀 스모크 테스트")
struct GenerateThumbnailPixelTests {
    @Test("텍스트/스티커가 없으면 셀 중심은 #3F3F3F, 캔버스 모서리는 배경색(#000000)에 가깝다")
    func backgroundAndCellColors() {
        var watermark = WatermarkModel()
        watermark.array = WatermarkArrayModel(type: .none, rows: 1, columns: 1)
        watermark.text.text = ""
        watermark.stickers = []

        let editor = WatermarkEditor(watermark: watermark, origins: [PImage.testFixture(width: 400, height: 600)])
        let thumbnail = editor.generateThumbnail()

        let corner = thumbnail.pixelColor(atX: 2, y: 2)
        let center = thumbnail.pixelColor(atX: 64, y: 64)

        #expect(corner != nil)
        #expect(center != nil)

        if let corner {
            #expect(corner.r < 10)
            #expect(corner.g < 10)
            #expect(corner.b < 10)
        }
        if let center {
            #expect(abs(Int(center.r) - 0x3F) <= 5)
            #expect(abs(Int(center.g) - 0x3F) <= 5)
            #expect(abs(Int(center.b) - 0x3F) <= 5)
        }
    }

    @Test("스티커를 그리면 스티커 위치의 픽셀이 셀 색상과 달라진다")
    func stickerChangesPixel() {
        var watermark = WatermarkModel()
        watermark.array = WatermarkArrayModel(type: .none, rows: 1, columns: 1)
        watermark.text.text = ""
        watermark.stickers = [
            WatermarkStickerModel(
                image: PImage.testFixture(width: 100, height: 100, fillColor: .red),
                alpha: 1,
                position: .zero,
                rotation: 0,
                scale: 3,
                layer: 0
            )
        ]

        let origins = [PImage.testFixture(width: 400, height: 600)]
        let editor = WatermarkEditor(watermark: watermark, origins: origins)
        let thumbnail = editor.generateThumbnail()

        let center = thumbnail.pixelColor(atX: 64, y: 64)
        #expect(center != nil)
        if let center {
            // 셀 색상(#3F3F3F)이 아니라 스티커(빨강) 영향으로 R 채널이 두드러지게 커야 함
            #expect(Int(center.r) > Int(center.b) + 30)
        }
    }
}
