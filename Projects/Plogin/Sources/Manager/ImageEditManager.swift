//
//  ImageEditManager.swift
//  Plogin
//
//  Created by AtenB on 8/9/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import UIKit

class ImageEditManager {
    func drawTextOnImage(
        image: UIImage,
        text: String,
        at point: CGPoint,
        font: UIFont =
            .systemFont(ofSize: 40),
        textColor: UIColor = .white
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)

        let newImage = renderer.image { context in
            // 1. 원본 이미지 그리기
            image.draw(in: CGRect(origin: .zero, size: image.size))

            // 2. 텍스트 스타일 설정
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left

            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]

            // 3. 텍스트 그리기
            let textRect = CGRect(origin: point, size: image.size)
            text.draw(in: textRect, withAttributes: attrs)
        }

        return newImage
    }
    
    func drawRepeatedTextOnImage(
        image: UIImage,
        text: String,
        textColor: UIColor = .black,
        font: UIFont = .systemFont(ofSize: 40),
        spacing: CGSize = CGSize(width: 200, height: 200)
    ) -> UIImage {
        let gradientColors: [UIColor] = [
            .blue.withAlphaComponent(0.3),
            .purple.withAlphaComponent(0.3),
            .systemPink.withAlphaComponent(0.3),
            .red.withAlphaComponent(0.3),
            .black.withAlphaComponent(0.3)
        ]
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let newImage = renderer.image { context in
            // 원본 이미지 그리기
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
//            context.cgContext.setFillColor(UIColor.cyan.withAlphaComponent(0.3).cgColor)
//            context.cgContext.fill(CGRect(origin: .zero, size: image.size))
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let cgColors = gradientColors.map { $0.cgColor } as CFArray
            let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil)!
                    
            let startPoint = CGPoint(x: 0, y: 0)
            let endPoint = CGPoint(x: image.size.width, y: image.size.height)
            
            context.cgContext.drawLinearGradient(
                gradient,
                start: startPoint,
                end: endPoint,
                options: []
            )
            // 텍스트 속성
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor
            ]
            
            // 바둑판처럼 텍스트 반복
            for y in stride(from: 0, to: image.size.height, by: spacing.height) {
                for x in stride(from: 0, to: image.size.width, by: spacing.width) {
                    let point = CGPoint(x: x, y: y)
                    text.draw(at: point, withAttributes: attributes)
                }
            }
        }
        
        return newImage
    }
}
