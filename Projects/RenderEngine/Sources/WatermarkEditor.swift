//
//  WatermarkEditor.swift
//  RenderEngine
//
//  Created by AtenB on 3/31/26.
//

import SwiftUI
import PlatformCore
import Photos

import WatermarkDomain
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public class WatermarkEditor {
    let format = WatermarkFormat()

    var origins: [PImage]
    var watermark: WatermarkModel

    public init(watermark: WatermarkModel, origins: [PImage]) {
        self.watermark = watermark
        self.origins = origins
    }

    public func generateWatermarks() -> [PImage] {
        guard !origins.isEmpty else { return [] }

        guard watermark.array.type != .none else {
            let referenceSize = format.getWatermarkImageSize(origins: origins, array: watermark.array)
            return origins.map { image in
                let size = format.getExportSize(for: image, export: watermark.export)
                return drawWatermark(on: image, exportSize: size, watermarkSize: referenceSize)
            }
        }

        let exportSize = watermark.export.getSize()
        let watermarkSize = format.getWatermarkImageSize(origins: origins, array: watermark.array)
        let merged = mergeImages(origins: origins, array: watermark.array, exportSize: exportSize)
        return [drawWatermark(on: merged, exportSize: exportSize, watermarkSize: watermarkSize)]
    }

    func drawWatermark(on image: PImage, exportSize: CGSize, watermarkSize: CGSize) -> PImage {
        let renderRatio = format.getRenderRatio(originSize: watermarkSize, renderSize: exportSize)

#if os(iOS)
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = true
        rendererFormat.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: exportSize, format: rendererFormat)

        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: exportSize))

            if !watermark.text.gradientColors.isEmpty {
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let cgColors = watermark.text.gradientColors.map { $0.toPColor.cgColor } as CFArray
                if let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil) {
                    context.cgContext.drawLinearGradient(
                        gradient,
                        start: .zero,
                        end: CGPoint(x: exportSize.width, y: exportSize.height),
                        options: []
                    )
                }
            }

            drawText(context: context, textSetting: watermark.text, exportSize: exportSize, renderRatio: renderRatio)
            drawStickers(context: context, stickers: watermark.stickers, exportSize: exportSize, renderRatio: renderRatio)
        }
#elseif os(macOS)
        return image
#endif
    }

    func drawStickers(
        context: UIGraphicsImageRendererContext,
        stickers: [WatermarkStickerModel],
        exportSize: CGSize,
        renderRatio: CGFloat
    ) {
        let canvasCenter = CGPoint(x: exportSize.width / 2, y: exportSize.height / 2)
        let orders = stickers.sorted(by: { $0.layer < $1.layer })

        for sticker in orders {
            let image = sticker.image
            let rotation = sticker.rotation
            let alpha = sticker.alpha
            let scale = sticker.scale * renderRatio
            let position = CGPoint(x: sticker.position.x * renderRatio, y: sticker.position.y * renderRatio)
            let anchor = CGPoint(x: canvasCenter.x + position.x, y: canvasCenter.y + position.y)

#if os(iOS)
            let originalSize = image.size
            let drawSize = CGSize(width: originalSize.width * scale, height: originalSize.height * scale)

            context.cgContext.saveGState()
            context.cgContext.setAlpha(alpha)
            context.cgContext.translateBy(x: anchor.x, y: anchor.y)
            context.cgContext.rotate(by: rotation * .pi / 180)
            context.cgContext.translateBy(x: -drawSize.width / 2, y: -drawSize.height / 2)
            image.draw(in: CGRect(origin: .zero, size: drawSize))
            context.cgContext.restoreGState()
#elseif os(macOS)
#endif
        }
    }

    func drawText(
        context: UIGraphicsImageRendererContext,
        textSetting: WatermarkTextModel,
        exportSize: CGSize,
        renderRatio: CGFloat
    ) {
        let fontSize = textSetting.fontSize * renderRatio
        let font = PFont(name: textSetting.fontName, size: fontSize) ?? PFont.systemFont(ofSize: fontSize)
        let text = format.getDisplayText(for: textSetting)

        let textArea = format.getTextArea(text: text, font: font, fontSize: fontSize)
        let spacing = CGSize(
            width: textSetting.spacingWidthRatio * textArea.width,
            height: textSetting.spacingHeightRatio * textArea.height
        )

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textSetting.color.toPColor
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let textSize = attributedText.size()

        let centerX = exportSize.width * 0.5
        let centerY = exportSize.height * 0.5
        let stepX = textArea.width + spacing.width
        let stepY = textArea.height + spacing.height
        let radians = textSetting.rotation * .pi / 180
        let cosTheta = cos(radians)
        let sinTheta = sin(radians)
        let u = CGVector(dx: cosTheta * stepX, dy: sinTheta * stepX)
        let v = CGVector(dx: -sinTheta * stepY, dy: cosTheta * stepY)

        let halfDiagonal = hypot(exportSize.width, exportSize.height) * 0.5
        let safeStepX = max(stepX, 1)
        let safeStepY = max(stepY, 1)
        let grid = format.getTextGrid(
            renderSize: exportSize,
            renderTextAreaSize: textArea,
            spacingRatioW: textSetting.spacingWidthRatio,
            spacingRatioH: textSetting.spacingHeightRatio
        )
        let columnRadius = max(Int(ceil(halfDiagonal / safeStepX)) + 2, grid.columns / 2 + 2)
        let rowRadius = max(Int(ceil(halfDiagonal / safeStepY)) + 2, grid.rows / 2 + 2)

#if os(iOS)
        let cgContext = context.cgContext
        for rowOffset in (-rowRadius)...rowRadius {
            for columnOffset in (-columnRadius)...columnRadius {
                let x = centerX
                    + CGFloat(columnOffset) * u.dx
                    + CGFloat(rowOffset) * v.dx
                let y = centerY
                    + CGFloat(columnOffset) * u.dy
                    + CGFloat(rowOffset) * v.dy

                let drawRect = CGRect(
                    x: -textSize.width * 0.5,
                    y: -textSize.height * 0.5,
                    width: textSize.width,
                    height: textSize.height
                )

                cgContext.saveGState()
                cgContext.translateBy(x: x, y: y)
                cgContext.rotate(by: radians)
                UIGraphicsPushContext(cgContext)
                attributedText.draw(in: drawRect)
                UIGraphicsPopContext()
                cgContext.restoreGState()
            }
        }
#elseif os(macOS)
#endif
    }
}

public extension WatermarkEditor {
    func mergeImages(origins: [PImage], array: WatermarkArrayModel, exportSize: CGSize) -> PImage {
        let cellSize = CGSize(
            width: exportSize.width / CGFloat(array.columns),
            height: exportSize.height / CGFloat(array.rows)
        )

#if os(iOS)
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = true
        rendererFormat.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: exportSize, format: rendererFormat)
        return renderer.image { context in
            placeGrid(
                context: context.cgContext,
                images: origins,
                rows: array.rows,
                columns: array.columns,
                cellSize: cellSize
            )
        }
#elseif os(macOS)
        return origins.first ?? PImage()
#endif
    }

    func placeGrid(
        context: CGContext,
        images: [PImage],
        rows: Int,
        columns: Int,
        cellSize: CGSize
    ) {
        for (index, image) in images.enumerated() {
            let row = (index / columns) + 1
            let column = (index % columns) + 1

            let x = CGFloat(column - 1) * cellSize.width
            let y = CGFloat(row - 1) * cellSize.height
            let cellRect = CGRect(x: x, y: y, width: cellSize.width, height: cellSize.height)

            context.setFillColor(PColor.black.cgColor)
            context.fill(cellRect)

            resizeFitImage(image: image, rect: cellRect, context: context)
        }
    }

    func resizeFitImage(
        image: PImage,
        rect: CGRect,
        context: CGContext
    ) {
        let imageSize = image.size
        guard imageSize.width > 0, imageSize.height > 0 else { return }

        // 비율을 유지한 채 최대 사이즈로 계산
        let scale = min(rect.width / imageSize.width, rect.height / imageSize.height)
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        let drawRect = CGRect(
            x: rect.minX + (rect.width - scaledWidth) / 2,
            y: rect.minY + (rect.height - scaledHeight) / 2,
            width: scaledWidth,
            height: scaledHeight
        )
#if os(iOS)
        image.draw(in: drawRect)
#elseif os(macOS)
        if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            context.draw(cgImage, in: drawRect)
        }
#endif
    }
}
