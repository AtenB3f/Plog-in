//
//  WatermarkTextModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct WatermarkTextModel: Codable {
    var text: String
    var fontName: String
    var fontSize: CGFloat
    var scale: CGFloat
    var color: ColorData
    var spacing: CGFloat
    var isGradient: Bool
    var isDate: Bool
    
    init(
        text: String,
        fontName: String,
        fontSize: CGFloat,
        scale: CGFloat,
        color: Color,
        alpha: CGFloat,
        spacing: CGFloat,
        isGradient: Bool,
        isDate: Bool
    ) {
        self.text = text
        self.fontName = fontName
        self.fontSize = fontSize
        self.scale = scale
        self.color = .init(color, alpha: alpha)
        self.spacing = spacing
        self.isGradient = isGradient
        self.isDate = isDate
    }
    
    enum CodingKeys: String, CodingKey {
        case text, fontName, fontSize, scale, color, spacing, isGradient, isDate
    }
}
