//
//  WatermarkThumbnailPreview.swift
//  RenderEngine
//

#if DEBUG
import SwiftUI
import PlatformCore
import WatermarkDomain
import Design

/// Preview 전용 더미 이미지 (픽셀 내용이 필요한 스티커 확인용으로 단색 채움)
private func makeDummyImage(width: CGFloat, height: CGFloat, color: PColor = .darkGray) -> PImage {
    let size = CGSize(width: width, height: height)
#if os(iOS)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
        color.setFill()
        UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()
    }
#elseif os(macOS)
    let image = NSImage(size: size)
    image.lockFocus()
    color.setFill()
    NSRect(origin: .zero, size: size).fill()
    image.unlockFocus()
    return image
#endif
}

private struct WatermarkThumbnailPreviewItem: Identifiable {
    let id = UUID()
    let title: String
    let image: PImage
}

private func makeThumbnailScenario(
    title: String,
    originsCount: Int,
    arrayType: WatermarkArrayType,
    gridRowColumn: (rows: Int, columns: Int)? = nil,
    text: String = "Plogin",
    textRotation: CGFloat = -30,
    textColor: ColorData = ColorData(red: 1, green: 1, blue: 1, opacity: 0.6),
    stickers: [WatermarkStickerModel] = []
) -> WatermarkThumbnailPreviewItem {
    let format = WatermarkFormat()
    let origins = (0..<originsCount).map { _ in makeDummyImage(width: 300, height: 600) }

    var array = format.makeArrayModel(origins: origins, type: arrayType, current: WatermarkArrayModel())
    if let gridRowColumn {
        array.rows = gridRowColumn.rows
        array.columns = gridRowColumn.columns
    }

    var textModel = WatermarkTextModel(
        text: text,
        fontName: FontType.body1.fontName,
        rotation: textRotation,
        color: textColor,
        date: nil
    )
    format.makeTextModel(origins: origins, array: array, current: &textModel)

    var watermark = WatermarkModel()
    watermark.array = array
    watermark.text = textModel
    watermark.stickers = stickers

    let editor = WatermarkEditor(watermark: watermark, origins: origins)
    return WatermarkThumbnailPreviewItem(title: title, image: editor.generateThumbnail())
}

private func makeThumbnailScenarios() -> [WatermarkThumbnailPreviewItem] {
    let centerSticker = WatermarkStickerModel(
        image: makeDummyImage(width: 300, height: 300, color: .systemBlue),
        alpha: 1,
        position: .zero,
        rotation: 20,
        scale: 0.4,
        layer: 0
    )
    let edgeStickers = [
        WatermarkStickerModel(
            image: makeDummyImage(width: 300, height: 300, color: .systemRed),
            alpha: 1,
            position: CGPoint(x: -4000, y: -3000),
            rotation: -15,
            scale: 0.3,
            layer: 0
        ),
        WatermarkStickerModel(
            image: makeDummyImage(width: 300, height: 300, color: .systemYellow),
            alpha: 0.8,
            position: CGPoint(x: 4000, y: 3000),
            rotation: 30,
            scale: 0.3,
            layer: 1
        )
    ]

    return [
        makeThumbnailScenario(title: "none (1x1) + text", originsCount: 1, arrayType: .none),
        makeThumbnailScenario(
            title: "horizontal (1x3) + text + sticker",
            originsCount: 3,
            arrayType: .horizontal,
            stickers: [centerSticker]
        ),
        makeThumbnailScenario(
            title: "vertical (3x1) + text rotation 90",
            originsCount: 3,
            arrayType: .vertical,
            textRotation: 90
        ),
        makeThumbnailScenario(
            title: "grid (2x2) + text + sticker 2개",
            originsCount: 4,
            arrayType: .grid,
            gridRowColumn: (2, 2),
            stickers: edgeStickers
        ),
        makeThumbnailScenario(
            title: "grid (6x6), text 없음, sticker 경계(clamp 확인)",
            originsCount: 6,
            arrayType: .grid,
            gridRowColumn: (6, 6),
            text: "",
            stickers: edgeStickers
        )
    ]
}

private struct WatermarkThumbnailPreviewGrid: View {
    let items: [WatermarkThumbnailPreviewItem]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 20) {
                ForEach(items) { item in
                    VStack(spacing: 8) {
                        Image(pImage: item.image)
                            .resizable()
                            .frame(width: 128, height: 128)
                            .border(Color.white.opacity(0.2))
                        Text(item.title)
                            .font(.caption)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding()
        }
        .background(Color.black)
    }
}

private func makeWatermarkThumbnailPreviewGrid() -> some View {
    WatermarkThumbnailPreviewGrid(items: makeThumbnailScenarios())
}

#Preview {
    makeWatermarkThumbnailPreviewGrid()
}
#endif
