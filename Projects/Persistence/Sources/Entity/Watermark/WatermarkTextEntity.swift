//
//  WatermarkTextEntity.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData
import PlatformCore

@Model
public final class WatermarkTextEntity {
    var text: String
    var fontName: String
    var fontSize: CGFloat
    var rotation: CGFloat
    var color: ColorData
    var spacingWidthRatio: CGFloat
    var spacingHeightRatio: CGFloat
    var date: Date?
    var gradientColors: [ColorData]

    var watermark: WatermarkEntity?

    public init(
        text: String = "",
        fontName: String = "",
        fontSize: CGFloat = .zero,
        rotation: CGFloat = .zero,
        color: ColorData = .init(red: .zero, green: .zero, blue: .zero, opacity: 0.25),
        spacingWidthRatio: CGFloat = .zero,
        spacingHeightRatio: CGFloat = .zero,
        date: Date? = Date(),
        gradientColors: [ColorData] = []
    ) {
        self.text = text
        self.fontName = fontName
        self.fontSize = fontSize
        self.rotation = rotation
        self.color = color
        self.spacingWidthRatio = spacingWidthRatio
        self.spacingHeightRatio = spacingHeightRatio
        self.date = date
        self.gradientColors = gradientColors
    }
}
