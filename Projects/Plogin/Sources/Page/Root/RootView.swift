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
    @StateObject var diContainer: DIContainer
    @ObservedObject var popupWatermark: WatermarkPopupCoordinator
    @ObservedObject var rootUI: RootUIManager

    init(diContainer: DIContainer = DIContainer()) {
        _diContainer = StateObject(wrappedValue: diContainer)
        _popupWatermark = ObservedObject(wrappedValue: diContainer.popupWatermark)
        _rootUI = ObservedObject(wrappedValue: diContainer.rootUI)
    }

    var body: some View {
        ZStack {
            switch rootUI.rootView {
            case .splash:
                SplashView(rootUI: rootUI)
            case .login:
                LoginView()
            case .navigation:
                TabNavigationView(diContainer: diContainer, viewModel: diContainer.makeTabNavigationVM())
            }
            if let data = rootUI.rootToast {
                Toast(data, callback: rootUI.toastAction)
                    .transition(.move(edge: .top))
            }

            if let watermarkPopup = popupWatermark.path.last {
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
