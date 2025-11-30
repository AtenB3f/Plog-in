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
        self.color = .init(color, alpha: alpha)
        self.spacingWidth = spacing.width
        self.spacingHeight = spacing.height
        self.isGradient = isGradient
        self.isDate = isDate
    }
    
    enum CodingKeys: String, CodingKey {
        case text, fontName, fontSize, rotation, color, spacingWidth, spacingHeight, isGradient, isDate
    }
}

public extension WatermarkTextModel {
    func getFont() -> PFont? {
        return .init(name: self.fontName, size: self.fontSize)
    }
    
    func getSpacing() -> CGSize {
        return .init(width: self.spacingWidth, height: self.spacingHeight)
    }
}
