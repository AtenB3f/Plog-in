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
    
    @StateObject var diContainer: DIContainer
    let viewModel: TabNavigationViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack(path: $diContainer.navigation.path) {
                VStack(spacing: 0) {
                    switch manager.currentTab {
                    case .home:
                        diContainer.makeHomeView()
                    case .setting:
                        SettingView()
                    }
                }
                .hiddenNavigationBarStyle()
                .navigations(diContainer: diContainer)
            }
            
//            TabBarView()
//                .environmentObject(navigation)
//                .environmentObject(manager)
        }
        .ignoresSafeArea(edges: .all)
    }
}

//#Preview {
//    TabNavigationView()
//}
