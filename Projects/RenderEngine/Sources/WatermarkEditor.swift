//
//  WatermarkEditor.swift
//  CoreDomain
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
    var format = WatermarkFormat()
    
    var images: [PImage]
    var watermark: WatermarkModel
    var gradient: [PColor] = []
    
    public init(watermark: WatermarkModel, images: [PImage]) {
        self.watermark = watermark
        self.images = images
    }
    
    public func generateWatermarks() -> [PImage] {
        var exportImage: [PImage] = []
        guard watermark.array.type != .none else {
            for image in images {
                exportImage.append(drawWatermark(image: image))
            }
            return exportImage
        }
        
        let arr = format.getRowColums(imageCount: images.count, array: watermark.array)
        let image = mergeImages(
            images: images,
            rows: arr.0,
            columns: arr.1,
            exportSize: watermark.export.getSize())
        exportImage.append(drawWatermark(image: image))
        return exportImage
    }

    func drawWatermark(image: PImage) -> PImage {
        let exportSize = watermark.export.getSize()
        
#if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: exportSize)
        
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: exportSize))
            
            if watermark.text.isGradient {
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let cgColors = gradient.map { $0.cgColor } as CFArray
                let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil)!
                
                let startPoint = CGPoint(x: 0, y: 0)
                let endPoint = CGPoint(x: image.size.width, y: image.size.height)
                
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: startPoint,
                    end: endPoint,
                    options: []
                )
            }
            drawStickers(context: context, stickers: watermark.stickers)
            drawText(context: context, textSetting: watermark.text, exportSize: exportSize)
        }
#elseif os(macOS)
#endif
    }
    
    func drawStickers(
        context: UIGraphicsImageRendererContext,
        stickers: [WatermarkStickerModel]
    ) {
        let canvasSize = context.format.bounds.size
        let canvasCenter = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
        let orders = stickers.sorted(by: { $0.layer < $1.layer })
        
        for sticker in orders {
            let image = sticker.image
            let rotation = sticker.rotation
            let alpha = sticker.alpha
            let position = sticker.position
            let scale = sticker.scale
            
            // position은 캔버스 중앙을 기준으로 한 오프셋으로 처리
            let anchor = CGPoint(x: canvasCenter.x + position.x, y: canvasCenter.y + position.y)
            
#if os(iOS)
            let originalSize = image.size
            let drawSize = CGSize(width: originalSize.width * scale, height: originalSize.height * scale)
            let drawOrigin = CGPoint(x: anchor.x - drawSize.width / 2, y: anchor.y - drawSize.height / 2)
            let drawRect = CGRect(origin: drawOrigin, size: drawSize)

            // 회전/알파 적용: 앵커(스티커 중심) 기준으로 회전 후 그리기
            context.cgContext.saveGState()
            context.cgContext.setAlpha(alpha)
            // 회전 중심으로 이동
            context.cgContext.translateBy(x: anchor.x, y: anchor.y)
            context.cgContext.rotate(by: rotation * .pi / 180)
            // 그리기 좌표계를 스티커 좌상단으로 이동
            context.cgContext.translateBy(x: -drawSize.width / 2, y: -drawSize.height / 2)
            image.draw(in: CGRect(origin: .zero, size: drawSize))
            context.cgContext.restoreGState()
#elseif os(macOS)
            let originalSize = image.size
            let drawSize = CGSize(width: originalSize.width * scale, height: originalSize.height * scale)
            let drawRect = CGRect(origin: .zero, size: drawSize)
            if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                context.cgContext.saveGState()
                context.cgContext.setAlpha(alpha)
                // 회전 중심으로 이동
                context.cgContext.translateBy(x: anchor.x, y: anchor.y)
                context.cgContext.rotate(by: rotation * .pi / 180)
                // 스티커 좌상단 기준으로 이동
                context.cgContext.translateBy(x: -drawSize.width / 2, y: -drawSize.height / 2)
                context.cgContext.draw(cgImage, in: drawRect)
                context.cgContext.restoreGState()
            }
#endif
        }
    }
    
    func drawText(
        context: UIGraphicsImageRendererContext,
        textSetting: WatermarkTextModel,
        exportSize: CGSize
    ) {
        guard let font =  PFont(name: textSetting.fontName, size: textSetting.fontSize) else { return }//textSetting.getPFont() else { return }
        var spacing: CGSize = .init(width: textSetting.spacingWidth, height: textSetting.spacingHeight)//textSetting.getSpacing()
        spacing.height = spacing.width
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textSetting.color.toPColor
        ]
        /*
        let text = textSetting.text + (textSetting.isDate ? ("\n" + Date.now()) : "")
        let textSize = text.getSize(font: font)
        
        let rotationAngle = textSetting.rotation * .pi / 180
        let rotatedWidth = abs(textSize.width * cos(rotationAngle)) + abs(textSize.height * cos(rotationAngle))
        let rotatedHeight = abs(textSize.width * sin(rotationAngle)) + abs(textSize.height * sin(rotationAngle))

        // 타일의 중앙에 회전된 텍스트 배치
        func drawTile(at origin: CGPoint) {
            context.cgContext.saveGState()
            context.cgContext.translateBy(x: origin.x + rotatedWidth/2, y: origin.y + rotatedHeight/2)
            context.cgContext.rotate(by: rotationAngle)
            context.cgContext.translateBy(x: -textSize.width / 2, y: -textSize.height / 2)
            text.draw(at: .init(x: 0, y: 0), withAttributes: attributes)
            context.cgContext.restoreGState()
        }
        
        // 이미지 중앙 좌표
        let center = CGPoint(x: exportSize.width / 2, y: exportSize.height / 2)

        // 타일 스텝 (회전된 외접 크기 + 간격)
        let stepX = rotatedWidth + spacing.width
        let stepY = rotatedHeight + spacing.height

        // 중앙 타일 먼저 그리기
        let centerOrigin = CGPoint(x: center.x - rotatedWidth/2, y: center.y - rotatedHeight/2)
        drawTile(at: centerOrigin)

        // 중앙에서 좌우/상하로 퍼져나가며 캔버스를 채우기
        let maxXRepeats = Int(ceil(exportSize.width / stepX / 2)) + 1
        let maxYRepeats = Int(ceil(exportSize.height / stepY / 2)) + 1
        for yi in 0...maxYRepeats {
            for xi in 0...maxXRepeats {
                if xi == 0 && yi == 0 { continue } // center already drawn
                let dx = (CGFloat(xi) * stepX)
                let dy = (CGFloat(yi) * stepY)
                drawTile(at: .init(x: centerOrigin.x + -dx, y: centerOrigin.y + -dy))
                drawTile(at: .init(x: centerOrigin.x + dx, y: centerOrigin.y + dy))
                drawTile(at: .init(x: centerOrigin.x + dx, y: centerOrigin.y + -dy))
                drawTile(at: .init(x: centerOrigin.x + -dx, y: centerOrigin.y + dy))
            }
        }
         */
    }
    
    func saveImageToPhotoLibrary(image: PImage) async throws -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            return true
            
        case .notDetermined:
            let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            if status == .authorized || status == .limited {
                try await PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
                return true
            }
            
        default:
            return false
        }
        return false
    }
}

public extension WatermarkEditor {
    func mergeImages(images: [PImage], rows: Int, columns: Int, exportSize: CGSize) -> PImage {
        let cellSize = format.getCellSize(images: images)
        // 최종 이미지 크기 계산
        let finalWidth = cellSize.width * CGFloat(rows)
        let finalHeight = cellSize.height * CGFloat(columns)
        let finalSize = CGSize(width: finalWidth, height: finalHeight)
        
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = true
        format.scale = 1.0
#if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: finalSize, format: format)
        return renderer.image { context in
            placeGrid(
                context: context.cgContext,
                images: images,
                rows: rows,
                columns: columns,
                cellSize: .init(width: cellSize.width, height: cellSize.height)
            )
        }
#elseif os(macOS)
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
            let row = (index/columns) + 1
            let column = (index%columns) + 1
            
            // 셀의 위치 계산
            let x = CGFloat(column-1) * cellSize.width
            let y = CGFloat(row-1) * cellSize.height
            let cellRect = CGRect(x: x, y: y, width: cellSize.width, height: cellSize.height)
            
            // 이미지를 셀 크기에 맞게 조정하여 그리기
            resizeFitImage(image: image, rect: cellRect, context: context)
        }
    }

    func resizeFitImage(
        image: PImage,
        rect: CGRect,
        context: CGContext
    ) {
        let imageSize = image.size
        let targetSize = rect.size
        var ratio: CGFloat = 1.0
        if targetSize.width > targetSize.height {
            ratio = imageSize.height / targetSize.height
        } else {
            ratio = imageSize.width / targetSize.width
        }
        let scaledWidth: CGFloat = imageSize.width * (ratio > 1 ? (1/ratio) : ratio)
        let scaledHeight: CGFloat = imageSize.height * (ratio > 1 ? (1/ratio) : ratio)
        let drawRect = CGRect(x: rect.minX,
                              y: rect.minY,
                              width: scaledWidth,
                              height: scaledHeight)
#if os(iOS)
        image.draw(in: drawRect)
#elseif os(macOS)
        if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            context.draw(cgImage, in: drawRect)
        }
#endif
    }
}
