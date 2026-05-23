//
//  WatermarkTextModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import PlatformCore

public struct WatermarkTextModel {
    public var text: String
    public var fontName: String
    public var fontSize: CGFloat
    public var rotation: CGFloat
    public var color: ColorData
    public var spacingWidth: CGFloat
    public var spacingHeight: CGFloat
    public var isGradient: Bool
    public var isDate: Bool
    
    public init(
        text: String = "",
        fontName: String = "",
        fontSize: CGFloat = .zero,
        rotation: CGFloat = .zero,
        color: ColorData = .init(red: .zero, green: .zero, blue: .zero, opacity: .zero),
        spacingWidth: CGFloat = .zero,
        spacingHeight: CGFloat = .zero,
        isGradient: Bool = true,
        isDate: Bool = true
    ) {
        self.text = text
        self.fontName = fontName
        self.fontSize = fontSize
        self.rotation = rotation
        self.color = color
        self.spacingWidth = spacingWidth
        self.spacingHeight = spacingHeight
        self.isGradient = isGradient
        self.isDate = isDate
    }
}

public extension WatermarkTextModel {
    var toPFont: PFont {
        return PFont(name: fontName, size: fontSize)!
    }
}
