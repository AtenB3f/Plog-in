//
//  Navigations.swift
//  Plogin
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

public extension View {
    func navigations(diContainer: DIContainer) -> some View {
        return self.navigationDestination(for: TabNavigationRouter.self) { type in
            diContainer.makeTabView(type)
                .hiddenNavigationBarStyle()
        }
    }
}
