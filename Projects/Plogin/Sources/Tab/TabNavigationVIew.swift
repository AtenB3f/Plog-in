//
//  TabNavigationVIew.swift
//  Plogin
//
//  Created by AtenB on 4/15/25.
//  Copyright © 2025 eone. All rights reserved.
//

import SwiftUI
import Design

struct TabNavigationView: View {
    @StateObject var diContainer: DIContainer
    let viewModel: TabNavigationViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack(path: $diContainer.navigation.path) {
                VStack(spacing: 0) {
                    switch diContainer.rootUI.currentTab {
                    case .home:
                        diContainer.makeHomeView()
                    case .setting:
                        SettingView()
                    }
                }
                .hiddenNavigationBarStyle()
                .navigations(diContainer: diContainer)
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}
