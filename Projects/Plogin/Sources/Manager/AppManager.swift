//
//  AppManager.swift
//  Plogin
//
//  Created by AtenB on 9/20/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Design
import WatermarkFeature

enum RootStatus {
    case splash
    case login
    case navigation
}

public final class AppManager: ObservableObject {
    public static var shared = AppManager()
    
    // MARK: Toast
    @Published var rootToast: ToastData?
    var toastAction: (() -> Void)?
    
    // MARK: Root
    @Published var rootView: RootStatus = .splash
    
    // MARK: Tab
    @Published var currentTab: Tab = .home
    
}

// MARK: Toast
public extension AppManager {
    @MainActor
    func pushToast(
        _ data: ToastData? = nil,
        _ duration: CGFloat? = 2.0,
        _ toastAction: (() -> Void)? = nil
    ) {
        self.toastAction = toastAction
        Task {
            withAnimation { rootToast = data }
            if let duration = duration {
                try await Task.sleep(for: .seconds(duration))
                withAnimation { rootToast = nil }
            }
        }
    }
}
