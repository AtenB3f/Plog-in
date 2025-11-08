//
//  TabNavigationVIew.swift
//  IPBox
//
//  Created by AtenB on 4/15/25.
//  Copyright © 2025 eone. All rights reserved.
//

import SwiftUI
import Design

struct TabNavigationView: View {
    @StateObject var manager = AppManager.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                NavigationTitle()
                
                NavigationRootLayout(path: $manager.path) {
                    VStack(spacing: 0) {
                        switch manager.currentTab {
                        case .home:
                            HomeView()
                        case .setting:
                            SettingView()
                        }
                    }
                    .hiddenNavigationBarStyle()
                    .navigations()
                }
            }
            
//            TabBarView()
//                .environmentObject(navigation)
//                .environmentObject(manager)
        }
        .ignoresSafeArea(edges: .bottom)
        .onReceive(NotificationCenter.default.publisher(for: .pushPopup)) { notification in
            if let type = notification.object as? PopupType {
                manager.pushPopup(type)
            } else {
                manager.pushPopup()
            }
        }
//        .onReceive(NotificationCenter.default.publisher(for: .logout)) { _ in
//            manager.logout()
//        }
    }
}

#Preview {
    TabNavigationView()
}
