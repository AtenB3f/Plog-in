//
//  TabNavigationViewModel.swift
//  IPBox
//
//  Created by AtenB on 4/15/25.
//  Copyright © 2025 eone. All rights reserved.
//

import SwiftUI

public class TabNavigationViewModel: ObservableObject {
    @Published var path = NavigationPath()
}

public extension TabNavigationViewModel {
    func pushRoot() {
        path = NavigationPath()
    }

    func push(_ value: Navigation) {
        path.append(value)
    }

    func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func pushPopup(_ type: PopupType? = nil) {
        NotificationCenter.default.post(name: .pushPopup, object: type)
    }
}
