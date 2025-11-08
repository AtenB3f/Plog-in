//
//  AppManager.swift
//  Plogin
//
//  Created by AtenB on 9/20/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Design

enum RootStatus {
    case splash
    case login
    case navigation
}

public final class AppManager: ObservableObject {
    public static var shared = AppManager()
    
    // MARK: Popup
    @Published var isRootPopup: Bool = false
    @Published var rootPopup: PopupType?
    
    // MARK: Root
    @Published var rootView: RootStatus = .splash
    
    // MARK: Tab
    @Published var currentTab: Tab = .home
    
    // MARK: Navigation
    @Published var path = NavigationPath()
}

// MARK: Popup
public extension AppManager {
    func pushPopup(_ type: PopupType? = nil) {
        isRootPopup = type != nil
        rootPopup = type
    }
}

// MARK: Navigation
public extension AppManager {
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
}
