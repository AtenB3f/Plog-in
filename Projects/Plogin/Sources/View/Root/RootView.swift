//
//  RootView.swift
//  Plogin
//
//  Created by AtenB on 4/16/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Design

struct RootView: View {
    @StateObject var manager = AppManager.shared
    
    var body: some View {
        ZStack {
            switch manager.rootView {
            case .splash:
                SplashView()
            case .login:
                LoginView()
            case .navigation:
                TabNavigationView()
            }
            if manager.isRootPopup, let type = manager.rootPopup {
                PopupView(type: type)
            }
        }
    }
}
