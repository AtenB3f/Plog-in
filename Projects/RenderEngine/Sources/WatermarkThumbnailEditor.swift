//
//  WatermarkThumbnailEditor.swift
//  RenderEngine
//
//  Created by AtenB on 8/31/26.
//

import SwiftUI
import PlatformCore
import WatermarkDomain

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public extension WatermarkEditor {
    private static let thumbnailSize: CGFloat = 128
    private static let thumbnailPadding: CGFloat = 12
    private static let thumbnailCellSpacing: CGFloat = 3
    private static let thumbnailCellCornerRadius: CGFloat = 2
    private static let thumbnailBackgroundColor = PColor.black
    private static let thumbnailCellColor = PColor(
        red: 0x3F / 255.0,
        green: 0x3F / 255.0,
        blue: 0x3F / 255.0,
        alpha: 1
    )

    /// WatermarkModel(array/text/stickers)을 이용한 128*128 썸네일 이미지를 생성
    func generateThumbnail() -> PImage {
        let canvasSize = CGSize(width: Self.thumbnailSize, height: Self.thumbnailSize)
        let region = CGRect(
            x: Self.thumbnailPadding,
            y: Self.thumbnailPadding,
            width: canvasSize.width - Self.thumbnailPadding * 2,
            height: canvasSize.height - Self.thumbnailPadding * 2
        )

#if os(iOS)
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = true
        rendererFormat.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: rendererFormat)

        return renderer.image { context in
            context.cgContext.setFillColor(Self.thumbnailBackgroundColor.cgColor)
            context.cgContext.fill(CGRect(origin: .zero, size: canvasSize))

            drawThumbnailArray(context: context.cgContext, region: region)
            drawThumbnailText(context: context, region: region)
            drawThumbnailStickers(context: context, region: region)
        }
#elseif os(macOS)
        return PImage()
#endif
    }
}

private extension WatermarkEditor {
    /// 1. 배열 타입: 배열 영역(104*104)을 array.rows * array.columns 셀로 나누어
    /// #3F3F3F 색상, cornerRadius 2px, 셀 간격 3px로 그림
    func drawThumbnailArray(context: CGContext, region: CGRect) {
        let rows = max(watermark.array.rows, 1)
        let columns = max(watermark.array.columns, 1)
        let spacing = Self.thumbnailCellSpacing

        let cellWidth = (region.width - CGFloat(columns - 1) * spacing) / CGFloat(columns)
        let cellHeight = (region.height - CGFloat(rows - 1) * spacing) / CGFloat(rows)
        guard cellWidth > 0, cellHeight > 0 else { return }

#if os(iOS)
        context.setFillColor(Self.thumbnailCellColor.cgColor)
        for row in 0..<rows {
            for column in 0..<columns {
                let x = region.minX + CGFloat(column) * (cellWidth + spacing)
                let y = region.minY + CGFloat(row) * (cellHeight + spacing)
                let cellRect = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
                let path = UIBezierPath(roundedRect: cellRect, cornerRadius: Self.thumbnailCellCornerRadius)
                context.addPath(path.cgPath)
                context.fillPath()
            }
        }
#elseif os(macOS)
#endif
    }

    /// 2. 텍스트: 텍스트는 배열 영역 중앙에 1회 그리고
    /// rotation/color/opacity를 적용해 region을 넘지 않는 최대 크기로 그림
    func drawThumbnailText(context: UIGraphicsImageRendererContext, region: CGRect) {
        let displayText = format.getDisplayText(for: watermark.text)
        guard !displayText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let referenceFontSize: CGFloat = 100
        let referenceFont: PFont
        if let resolved = PFont(name: watermark.text.fontName, size: referenceFontSize) {
            referenceFont = resolved
        } else {
            crashReport?.send(
                title: "WatermarkEditor",
                function: "drawThumbnailText",
                key: "fontName",
                value: watermark.text.fontName,
                error: RenderEngineError.fontNotFound(name: watermark.text.fontName)
            )
            referenceFont = PFont.systemFont(ofSize: referenceFontSize)
        }
        let baseSize = format.getTextArea(text: displayText, font: referenceFont, fontSize: referenceFontSize)
        guard baseSize.width > 0, baseSize.height > 0 else { return }

        let radians = watermark.text.rotation * .pi / 180
        let cosTheta = abs(cos(radians))
        let sinTheta = abs(sin(radians))
        let rotatedUnitWidth = baseSize.width * cosTheta + baseSize.height * sinTheta
        let rotatedUnitHeight = baseSize.width * sinTheta + baseSize.height * cosTheta
        guard rotatedUnitWidth > 0, rotatedUnitHeight > 0 else { return }

        // 회전된 바운딩 박스가 region을 넘지 않는 최대 scale로 폰트 크기를 역산
        let scale = min(region.width / rotatedUnitWidth, region.height / rotatedUnitHeight)
        let fontSize = referenceFontSize * scale
        guard fontSize > 0 else { return }

        let drawFont: PFont
        if let resolved = PFont(name: watermark.text.fontName, size: fontSize) {
            drawFont = resolved
        } else {
            crashReport?.send(
                title: "WatermarkEditor",
                function: "drawThumbnailText",
                key: "fontName",
                value: watermark.text.fontName,
                error: RenderEngineError.fontNotFound(name: watermark.text.fontName)
            )
            drawFont = PFont.systemFont(ofSize: fontSize)
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: drawFont,
            .foregroundColor: watermark.text.color.toPColor
        ]
        let attributedText = NSAttributedString(string: displayText, attributes: attributes)
        let textSize = attributedText.size()
        let drawRect = CGRect(
            x: -textSize.width / 2,
            y: -textSize.height / 2,
            width: textSize.width,
            height: textSize.height
        )

#if os(iOS)
        let cgContext = context.cgContext
        cgContext.saveGState()
        cgContext.translateBy(x: region.midX, y: region.midY)
        cgContext.rotate(by: radians)
        UIGraphicsPushContext(cgContext)
        attributedText.draw(in: drawRect)
        UIGraphicsPopContext()
        cgContext.restoreGState()
#elseif os(macOS)
#endif
    }

    /// 3. 스티커: 실제 워터마크 캔버스(origins 기반 watermarkImageSize) 대비
    /// region(104*104) 비율(renderRatio)로 크기/좌표를 환산해 layer 순서대로 그림
    func drawThumbnailStickers(context: UIGraphicsImageRendererContext, region: CGRect) {
        let watermarkImageSize = format.getWatermarkImageSize(origins: origins, array: watermark.array)
        guard watermarkImageSize.width > 0 else { return }
        let renderRatio = region.width / watermarkImageSize.width

        let orderedStickers = watermark.stickers.sorted(by: { $0.layer < $1.layer })
        let halfRegionWidth = region.width / 2
        let halfRegionHeight = region.height / 2

        for sticker in orderedStickers {
            let image = sticker.image
            guard image.size.width > 0, image.size.height > 0 else { continue }

            let scale = sticker.scale * renderRatio
            guard scale > 0 else { continue }
            var drawSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

            // 스티커 자체가 region보다 큰 경우 region 안에 들어오도록 추가로 축소
            if drawSize.width > region.width || drawSize.height > region.height {
                let fitScale = min(region.width / drawSize.width, region.height / drawSize.height)
                drawSize = CGSize(width: drawSize.width * fitScale, height: drawSize.height * fitScale)
            }

            let radians = sticker.rotation * .pi / 180
            let cosTheta = abs(cos(radians))
            let sinTheta = abs(sin(radians))
            let halfRotatedWidth = (drawSize.width * cosTheta + drawSize.height * sinTheta) / 2
            let halfRotatedHeight = (drawSize.width * sinTheta + drawSize.height * cosTheta) / 2

            let maxOffsetX = max(halfRegionWidth - halfRotatedWidth, 0)
            let maxOffsetY = max(halfRegionHeight - halfRotatedHeight, 0)

            var position = CGPoint(x: sticker.position.x * renderRatio, y: sticker.position.y * renderRatio)
            position.x = min(max(position.x, -maxOffsetX), maxOffsetX)
            position.y = min(max(position.y, -maxOffsetY), maxOffsetY)

            let anchor = CGPoint(x: region.midX + position.x, y: region.midY + position.y)

#if os(iOS)
            let cgContext = context.cgContext
            cgContext.saveGState()
            cgContext.setAlpha(sticker.alpha)
            cgContext.translateBy(x: anchor.x, y: anchor.y)
            cgContext.rotate(by: radians)
            cgContext.translateBy(x: -drawSize.width / 2, y: -drawSize.height / 2)
            image.draw(in: CGRect(origin: .zero, size: drawSize))
            cgContext.restoreGState()
#elseif os(macOS)
#endif
        }
    }
}
