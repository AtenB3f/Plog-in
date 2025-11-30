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
        let image = mergeImages(images: images, rows: rows, columns: columns)
        watermarks.append(drawWatermark(image: image, watermark: watermark))
        return watermarks
    }

    func drawWatermark(image: PImage, watermark: WatermarkModel) -> PImage {
        guard let font = watermark.textSetting.getFont() else { return image }
        let size = watermark.exportSetting.getRect()
        var spacing: CGSize = watermark.textSetting.getSpacing()
        spacing.height = spacing.width
        let gradientColor: [UIColor] = Color.disablePrimarys.map { PColor($0.opacity(0.3)) }
#if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            
            image.draw(in: CGRect(origin: .zero, size: size))
            
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
            for y in stride(from: 0, to: size.height + stepY, by: stepY) {
                for x in stride(from: 0, to: size.width + stepX, by: stepX) {
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
        let newImage = PImage(size: image.size)
        newImage.lockFocus()
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            newImage.unlockFocus()
            return image
        }
        
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = gradientColors.map { $0.cgColor } as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil)!
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: image.size.width, y: image.size.height)
        
        context.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: []
        )
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        
        for y in stride(from: 0, to: image.size.height, by: spacing.height) {
            for x in stride(from: 0, to: image.size.width, by: spacing.width) {
                let point = CGPoint(x: x, y: y)
                text.draw(at: point, withAttributes: attributes)
            }
        }
        
        newImage.unlockFocus()
        return newImage
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
    func mergeImages(images: [PImage], rows: Int, columns: Int) -> PImage {
        // 첫 번째 이미지를 기준으로 설정
        let referenceImage = images[0]
        let cellSize = referenceImage.size
        
        // 최종 이미지 크기 계산
        let finalWidth = cellSize.width * CGFloat(columns)
        let finalHeight = cellSize.height * CGFloat(rows)
        let finalSize = CGSize(width: finalWidth, height: finalHeight)
        
        #if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: finalSize)
        return renderer.image { context in
            placeGrid(
                images: images,
                rows: rows,
                columns: columns,
                cellSize: cellSize,
                context: context.cgContext
            )
        }
        #elseif os(macOS)
        let finalImage = NSImage(size: finalSize)
        finalImage.lockFocus()
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            finalImage.unlockFocus()
            return nil
        }
        
        placeGrid(
            images: images,
            rows: rows,
            columns: columns,
            cellSize: cellSize,
            context: context
        )
        
        finalImage.unlockFocus()
        return finalImage
        #endif
    }

    /// 그리드에 이미지를 그리는 헬퍼 함수
    /// - Parameters:
    ///   - images: 그릴 이미지 배열
    ///   - rows: 행 개수
    ///   - columns: 열 개수
    ///   - cellSize: 각 셀의 크기
    ///   - context: 그래픽 컨텍스트
    private func placeGrid(
        images: [PImage],
        rows: Int,
        columns: Int,
        cellSize: CGSize,
        context: CGContext
    ) {
        for (index, image) in images.enumerated() {
            let row = index / columns
            let column = index % columns
            
            guard row < rows else { break }
            
            // 셀의 위치 계산
            let x = CGFloat(column) * cellSize.width
            let y = CGFloat(row) * cellSize.height
            let cellRect = CGRect(x: x, y: y, width: cellSize.width, height: cellSize.height)
            
            // 이미지를 셀 크기에 맞게 조정하여 그리기
            resizeImage(image: image, in: cellRect, context: context)
        }
    }

    /// 이미지를 주어진 영역에 꽉 차게 그리는 함수 (비율 유지, 크롭)
    /// - Parameters:
    ///   - image: 그릴 이미지
    ///   - rect: 그릴 영역
    ///   - context: 그래픽 컨텍스트
    private func resizeImage(
        image: PImage,
        in rect: CGRect,
        context: CGContext
    ) {
        let imageSize = image.size
        
        // 이미지와 셀의 비율 계산
        let imageAspect = imageSize.width / imageSize.height
        let rectAspect = rect.width / rect.height
        
        var drawRect = CGRect.zero
        
        if imageAspect > rectAspect {
            // 이미지가 더 넓음 - 높이를 맞추고 너비를 크롭
            let scaledWidth = rect.height * imageAspect
            drawRect = CGRect(
                x: rect.minX - (scaledWidth - rect.width) / 2,
                y: rect.minY,
                width: scaledWidth,
                height: rect.height
            )
        } else {
            // 이미지가 더 높음 - 너비를 맞추고 높이를 크롭
            let scaledHeight = rect.width / imageAspect
            drawRect = CGRect(
                x: rect.minX,
                y: rect.minY - (scaledHeight - rect.height) / 2,
                width: rect.width,
                height: scaledHeight
            )
        }
        
        // 클리핑 영역 설정
        context.saveGState()
        context.clip(to: rect)
        
        #if os(iOS)
        image.draw(in: drawRect)
        #elseif os(macOS)
        if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            context.draw(cgImage, in: drawRect)
        }
        #endif
        
        context.restoreGState()
    }
}
