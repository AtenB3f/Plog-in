//
//  CommonModel.swift
//  Plogin
//
//  Created by AtenB on 10/21/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct ColorData: Codable, Equatable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var opacity: CGFloat
    
    var toUI: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    var toP: PColor {
        PColor(Color(red: red, green: green, blue: blue, opacity: opacity))
    }
    
    init(_ color: Color, alpha: Double = 1.0) {
        let uiColor = PColor(color.opacity(alpha))
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        self.red = r
        self.green = g
        self.blue = b
        self.opacity = a
    }
    
    enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }
}
