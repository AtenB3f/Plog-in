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

    var body: some View {
        ZStack {
            switch diContainer.rootUI.rootView {
            case .splash:
                SplashView(rootUI: diContainer.rootUI)
            case .login:
                LoginView()
            case .navigation:
                TabNavigationView(diContainer: diContainer, viewModel: diContainer.makeTabNavigationVM())
            }
            if let data = diContainer.rootUI.rootToast {
                Toast(data, callback: diContainer.rootUI.toastAction)
                    .transition(.move(edge: .top))
            }
            
            if let watermarkPopup = diContainer.popupWatermark.path.last {
                ZStack {
                    Color.Shadow.medium
                        .ignoresSafeArea()
                    
                    diContainer.makeWatermarkPopup(watermarkPopup)
                        .padding(.horizontal, 30)
                }
                .transition(.opacity)
            }
        }
    }
}
