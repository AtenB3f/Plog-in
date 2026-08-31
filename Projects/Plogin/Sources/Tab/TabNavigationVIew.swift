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
    @ObservedObject var diContainer: DIContainer
    @ObservedObject var navigation: TabNavigaionCoordinator
    @ObservedObject var rootUI: RootUIManager
    let viewModel: TabNavigationViewModel

    init(diContainer: DIContainer, viewModel: TabNavigationViewModel) {
        self.diContainer = diContainer
        self.navigation = diContainer.navigation
        self.rootUI = diContainer.rootUI
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack(path: $navigation.path) {
                VStack(spacing: 0) {
                    switch rootUI.currentTab {
                    case .home:
                        diContainer.makeHomeView()
                    case .setting:
                        EmptyView()
                    }
                }
                .hiddenNavigationBarStyle()
                .navigations(diContainer: diContainer)
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}
