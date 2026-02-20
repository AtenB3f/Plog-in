//
//  WatermarkManager.swift
//  Plogin
//
//  Created by AtenB on 8/9/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import Design
import SwiftUI
import Photos
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

class WatermarkManager {
    func generateWatermarks(_ images: [PImage], watermark: WatermarkModel) -> [PImage] {
        var exportImage: [PImage] = []
        guard watermark.arraySetting.type != .none else {
            for image in images {
                exportImage.append(drawWatermark(image: image, watermark: watermark))
            }
            return exportImage
        }
        
        let arr = getRowColums(imageCount: images.count, watermark: watermark)
        let image = mergeImages(
            images: images,
            rows: arr.0,
            columns: arr.1,
            exportSize: watermark.exportSetting.getSize())
        exportImage.append(drawWatermark(image: image, watermark: watermark))
        return exportImage
    }
    
    func getRowColums(imageCount: Int, watermark: WatermarkModel) -> (Int, Int) {
        let arrayType = watermark.arraySetting.type
        var rows = 1
        var columns = 1
        switch arrayType {
        case .none:
            break
        case .horizontal:
            rows = 1
            columns = imageCount
        case .vertical:
            rows = imageCount
            columns = 1
        case .grid:
            rows = watermark.arraySetting.rows
            columns = watermark.arraySetting.columns
        }
        return (rows, columns)
    }
    
    /// 이미지 리스트 중 첫 번째 이미지의 너비와 기준 이미지 너비로 이미지들의 너비를 조정했을 때 가장 값이 큰 높이를 구하는 함수
    func getCellSize(images: [PImage]) -> CGSize {
        // 첫 번째 이미지를 기준으로 설정
        let referenceImage = images[0]
        var cellSize = referenceImage.size
        cellSize.height = (images.map { $0.size.height/$0.size.width }.max() ?? 1.0) * referenceImage.size.width
        
        return cellSize
    }

    func drawWatermark(image: PImage, watermark: WatermarkModel) -> PImage {
        let exportSize = watermark.exportSetting.getSize()
        
        let gradientColor: [UIColor] = Color.disablePrimarys.map { PColor($0.opacity(0.3)) }
#if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: exportSize)
        
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: exportSize))
            
            if watermark.textSetting.isGradient {
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let cgColors = gradientColor.map { $0.cgColor } as CFArray
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
            drawText(context: context, textSetting: watermark.textSetting, exportSize: exportSize)
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
            guard let image = sticker.image else { continue }
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
        guard let font = textSetting.getPFont() else { return }
        var spacing: CGSize = textSetting.getSpacing()
        spacing.height = spacing.width
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textSetting.color.toP
        ]
        
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
            text.draw(at: .zero, withAttributes: attributes)
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

extension WatermarkManager {
    func mergeImages(images: [PImage], rows: Int, columns: Int, exportSize: CGSize) -> PImage {
        let cellSize = getCellSize(images: images)
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

#Preview {
    let manager = WatermarkManager()
    var images: [Image] {
        get {
            if let pimage = PImage(systemName: "star") {
                let result = manager.generateWatermarks(
                    [pimage],
                    watermark: .init(
                        textSetting: .init(text: "plli",
                                           fontName: FontType.body1.fontName,
                                           fontSize: 10,
                                           rotation: -20.0,
                                           color: .red,
                                           alpha: 1,
                                           spacing: .init(width: 20, height: 20),
                                           isGradient: true,
                                           isDate: true),
                        stickers: [],
                        arraySetting: .init(type: .none, rows: 1, columns: 1),
                        exportSetting: .init(type: .auto, size: .init(width: 200, height: 200)),
                        frameSetting: .init(title: "Melon_Streaming", type: .basic)
                    )
                )
                return result.compactMap{ Image(uiImage: $0) }
            } else {
                return []
            }
        }
    }
    
    VStack {
        ForEach(images.indices) {index in
            images[index]
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
        }
    }
}

//#Preview {
//    let manager = WatermarkManager()
//    var images: [Image] {
//        get {
//            if let pimage = PImage(systemName: "star") {
//                let result = manager.generateWatermarks(
//                    [pimage],
//                    watermark: .init(
//                        textSetting: .init(text: "plli",
//                                           fontName: FontType.body1.fontName,
//                                           fontSize: 10,
//                                           rotation: -20.0,
//                                           color: .red,
//                                           alpha: 1,
//                                           spacing: .init(width: 20, height: 20),
//                                           isGradient: true,
//                                           isDate: true),
//                        stickers: [],
//                        arraySetting: .init(type: .none, rows: 1, columns: 1),
//                        exportSetting: .init(type: .auto, size: .init(width: 200, height: 200)),
//                        frameSetting: .init(title: "Melon_Streaming", type: .basic)
//                    )
//                )
//                return result.compactMap{ Image(uiImage: $0) }
//            } else {
//                return []
//            }
//        }
//    }
//    
//    VStack {
//        ForEach(images.indices) {index in
//            images[index]
//                .resizable()
//                .frame(width: 300, height: 300, alignment: .center)
//        }
//    }
//}
