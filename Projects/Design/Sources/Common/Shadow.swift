//
//  Shadow.swift
//  Design
//
//  Created by AtenB on 10/18/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public enum ShadowType {
    case none
    case disable
    case light
    case medium
    case dark
}

public extension View {
    func shadow(_ type: ShadowType) -> some View {
        switch type {
        case .disable:
            return self.shadow(color: .Shadow.disable, radius: 6, x: 2, y: 4)
        case .light:
            return self.shadow(color: .Shadow.light, radius: 4, x: 0, y: 0)
        case .medium:
            return self.shadow(color: .Shadow.medium, radius: 6, x: 0, y: 0)
        case .dark:
            return self.shadow(color: .Shadow.dark, radius: 4, x: 0, y: 0)
        default:
            return self.shadow(color: .clear, radius: 0, x: 0, y: 0)
        }
    }
}

#Preview {
    Text("Text")
        .shadow(.dark)
}
