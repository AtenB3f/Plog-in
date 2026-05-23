//
//  RootView.swift
//  Plogin
//
//  Created by AtenB on 4/16/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Design
import WatermarkFeature

struct RootView: View {
    @StateObject var diContainer = DIContainer()
    @StateObject var manager = AppManager.shared
    
    var body: some View {
        ZStack {
            switch manager.rootView {
            case .splash:
                SplashView()
            case .login:
                LoginView()
            case .navigation:
                TabNavigationView(diContainer: diContainer, viewModel: diContainer.makeTabNavigationVM())
            }
            if let data = manager.rootToast {
                Toast(data, callback: manager.toastAction)
                    .transition(.move(edge: .top))
            }
            
            if let watermarkPopup = diContainer.popupWatermark.path.last {
                WatermarkPopup(type: watermarkPopup, coordinator: diContainer.makeWatermarkPopupCoordinator())
                    .transition(.opacity)
            }
        }
    }
}
