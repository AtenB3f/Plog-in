//
//  WatermarkTextModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

public struct WatermarkTextModel: Codable {
    var text: String
    var fontName: String
    var fontSize: CGFloat
    var rotation: CGFloat
    var scale: CGFloat
    var color: ColorData
    var spacingWidth: CGFloat
    var spacingHeight: CGFloat
    var isGradient: Bool
    var isDate: Bool
    
    init(
        text: String = "",
        fontName: String = "",
        fontSize: CGFloat = .zero,
        rotation: CGFloat = .zero,
        scale: CGFloat = 1.0,
        color: Color = .clear,
        alpha: CGFloat = .zero,
        spacing: CGSize = .zero,
        isGradient: Bool = true,
        isDate: Bool = true
    ) {
        self.text = text
        self.fontName = fontName
        self.fontSize = fontSize
        self.rotation = rotation
        self.scale = scale
        self.color = .init(color, alpha: alpha)
        self.spacingWidth = spacing.width
        self.spacingHeight = spacing.height
        self.isGradient = isGradient
        self.isDate = isDate
    }
    
    enum CodingKeys: String, CodingKey {
        case text, fontName, fontSize, rotation, scale, color, spacingWidth, spacingHeight, isGradient, isDate
    }
}

public extension WatermarkTextModel {
    func getPFont() -> PFont? {
        return .init(name: self.fontName, size: self.fontSize)
    }
    
    func getFont() -> Font {
        return .custom(self.fontName, size: self.fontSize)
    }
    
    func getFontSize(_ imageSize: CGFloat) -> CGFloat {
        return imageSize * 24 / 650
    }
    
    func getSpacing() -> CGSize {
        return .init(width: self.spacingWidth, height: self.spacingHeight)
    }
}
