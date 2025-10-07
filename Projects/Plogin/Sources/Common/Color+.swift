//
//  Color+.swift
//  Plogin
//
//  Created by AtenB on 8/13/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import UIKit

extension Color {
    func toUI(_ opacity: CGFloat = 1.0) -> UIColor {
        return UIColor(self).withAlphaComponent(opacity)
    }
}

extension UIColor {
    func toColor(_ opacity: CGFloat = 1.0) -> Color {
        return Color(self).opacity(opacity)
    }
}
