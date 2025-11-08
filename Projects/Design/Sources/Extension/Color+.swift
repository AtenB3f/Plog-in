//
//  Color+.swift
//  Plogin
//
//  Created by AtenB on 8/13/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI

public extension Color {
    func toUI(_ opacity: CGFloat = 1.0) -> PColor {
        return PColor(self).withAlphaComponent(opacity)
    }
}

public extension PColor {
    func toColor(_ opacity: CGFloat = 1.0) -> Color {
        return Color(self).opacity(opacity)
    }
}
