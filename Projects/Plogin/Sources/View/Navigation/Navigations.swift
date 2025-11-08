//
//  Navigations.swift
//  Plogin
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public enum Navigation: Hashable {
    case watermark
}

public extension View {
    func navigations() -> some View {
        return self.navigationDestination(for: Navigation.self) { type in
            switch type {
            case .watermark:
                WatermarkEditView()
                    .hiddenNavigationBarStyle()
                
            default:
                EmptyView()
                    .hiddenNavigationBarStyle()
            }
        }
    }
}
