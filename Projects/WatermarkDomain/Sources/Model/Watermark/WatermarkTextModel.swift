//
//  WatermarkTextModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import PlatformCore

public struct WatermarkTextModel: Hashable {
    public var text: String
    public var fontName: String
    public var fontSize: CGFloat
    public var rotation: CGFloat
    public var color: ColorData
    public var spacingWidthRatio: CGFloat
    public var spacingHeightRatio: CGFloat
    public var date: Date?
    public var gradientColors: [ColorData]

    public init(
        text: String = "",
        fontName: String = "",
        fontSize: CGFloat = .zero,
        rotation: CGFloat = .zero,
        color: ColorData = .init(red: .zero, green: .zero, blue: .zero, opacity: .zero),
        spacingWidthRatio: CGFloat = .zero,
        spacingHeightRatio: CGFloat = .zero,
        date: Date? = nil,
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

public extension WatermarkTextModel {
    var toPFont: PFont {
        // TODO: font name에 맞는 폰트가 없을 경우의 정책 필요
        return PFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize)
    }

    var isGradient: Bool {
        !gradientColors.isEmpty
    }
}
