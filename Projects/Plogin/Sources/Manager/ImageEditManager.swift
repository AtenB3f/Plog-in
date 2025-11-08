//
//  ImageEditManager.swift
//  Plogin
//
//  Created by AtenB on 8/9/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import Design
import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

class ImageEditManager {
    func drawTextOnImage(
        image: PImage,
        text: String,
        at point: CGPoint,
        font: PFont = .systemFont(ofSize: 40),
        textColor: PColor = .white
    ) -> PImage {
#if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            
            let textRect = CGRect(origin: point, size: image.size)
            text.draw(in: textRect, withAttributes: attrs)
        }
#elseif os(macOS)
        let newImage = PImage(size: image.size)
        newImage.lockFocus()
        
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let textRect = CGRect(origin: point, size: image.size)
        text.draw(in: textRect, withAttributes: attrs)
        
        newImage.unlockFocus()
        return newImage
#endif
    }
    
    func drawRepeatedTextOnImage(
        image: PImage,
        text: String,
        textColor: PColor = .black,
        font: PFont = .systemFont(ofSize: 40),
        spacing: CGSize = CGSize(width: 200, height: 200)
    ) -> PImage {
        let gradientColors: [PColor] = [
            .blue.withAlphaComponent(0.3),
            .purple.withAlphaComponent(0.3),
            .systemPink.withAlphaComponent(0.3),
            .red.withAlphaComponent(0.3),
            .black.withAlphaComponent(0.3)
        ]
        
#if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
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
}
