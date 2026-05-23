//
//  Color+.swift
//  Plogin
//
//  Created by AtenB on 8/13/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI

public struct ColorData: Codable, Equatable {
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var opacity: CGFloat
    
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }
    
    enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }
}

public extension ColorData {
    var toColor: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }

    var toPColor: PColor {
        PColor(Color(red: red, green: green, blue: blue, opacity: opacity))
    }
    
    init(_ color: Color, alpha: Double = 1.0) {
        let uiColor = PColor(color.opacity(alpha))
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

public extension Color {
    func toPColor(_ opacity: CGFloat = 1.0) -> PColor {
        return PColor(self).withAlphaComponent(opacity)
    }
}

public extension PColor {
    func toColor(_ opacity: CGFloat = 1.0) -> Color {
        return Color(self).opacity(opacity)
    }
}
