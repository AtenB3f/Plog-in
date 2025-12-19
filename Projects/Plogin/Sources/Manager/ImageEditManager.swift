//
//  ImageEditManager.swift
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

class ImageEditManager {
    func generateWatermarks(_ images: [PImage], watermark: WatermarkModel) -> [PImage] {
        var watermarks: [PImage] = []
        let arrayType = watermark.arraySetting.type
        var rows: Int = 1
        var columns: Int = 1
        switch arrayType {
        case .none:
            for image in images {
                watermarks.append(drawWatermark(image: image, watermark: watermark))
            }
            return watermarks
        case .horizontal:
            rows = 1
            columns = watermarks.count
        case .vertical:
            rows = watermarks.count
            columns = 1
        case .grid:
            rows = watermark.arraySetting.rows
            columns = watermark.arraySetting.columns
        }
        let image = mergeImages(images: images, rows: rows, columns: columns, exportSize: watermark.exportSetting.getSize())
        watermarks.append(drawWatermark(image: image, watermark: watermark))
        return watermarks
    }

    func drawWatermark(image: PImage, watermark: WatermarkModel) -> PImage {
        guard let font = watermark.textSetting.getFont() else { return image }
        let exportSize = watermark.exportSetting.getSize()
        var spacing: CGSize = watermark.textSetting.getSpacing()
        spacing.height = spacing.width
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
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: watermark.textSetting.color.toP
            ]
            
            let text = watermark.textSetting.text + (watermark.textSetting.isDate ? ("\n" + Date.now()) : "")
            let textSize = text.getSize(font: font)
            
            let rotationAngle = watermark.textSetting.rotation * .pi / 180
            let rotatedWidth = abs(textSize.width * cos(rotationAngle)) + abs(textSize.height * sin(rotationAngle))
            let rotatedHeight = abs(textSize.width * sin(rotationAngle)) + abs(textSize.height * cos(rotationAngle))
            
            let stepX = rotatedWidth + spacing.width
            let stepY = rotatedHeight + spacing.height
            for y in stride(from: 0, to: exportSize.height + stepY, by: stepY) {
                for x in stride(from: 0, to: exportSize.width + stepX, by: stepX) {
                    let point = CGPoint(x: x, y: y)
                    
                    context.cgContext.saveGState()
                    context.cgContext.translateBy(x: point.x + textSize.width / 2,
                                                  y: point.y + textSize.height / 2)
                    context.cgContext.rotate(by: rotationAngle)
                    context.cgContext.translateBy(x: -textSize.width / 2,
                                                  y: -textSize.height / 2)
                    text.draw(at: .zero, withAttributes: attributes)
                    context.cgContext.restoreGState()
                }
            }
        }
#elseif os(macOS)
#endif
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

extension ImageEditManager {
    func mergeImages(images: [PImage], rows: Int, columns: Int, exportSize: CGSize) -> PImage {
        // 첫 번째 이미지를 기준으로 설정
        let referenceImage = images[0]
        var cellSize = referenceImage.size
        cellSize.height = (images.map { $0.size.height/$0.size.width }.max() ?? 1.0) * referenceImage.size.width
        
        // 최종 이미지 크기 계산
        let finalWidth = cellSize.width * CGFloat(columns)
        let finalHeight = cellSize.height * CGFloat(rows)
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
                cellSize: .init(width: exportSize.width/CGFloat(columns), height: exportSize.height/CGFloat(rows))
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
