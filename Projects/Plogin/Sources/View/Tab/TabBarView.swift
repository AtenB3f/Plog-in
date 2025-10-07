//
//  TabBarView.swift
//  IPBOX
//
//  Created by AtenB on 7/16/25.
//  Copyright © 2025 metaparts. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var manager: AppManager
    @EnvironmentObject var navigation: TabNavigationViewModel
    
    var body: some View {
        // Bottom Tabbar List
        VStack(spacing: 0) {
            HStack(spacing: 60) {
                Button {
                    navigation.pushRoot()
                    manager.currentTab = .connect
                } label: {
                    Image(manager.currentTab == Tab.connect ? "" : "")
                }
                .basicButtonStyle(.basic)
                
                Button {
                    navigation.pushRoot()
                    manager.currentTab = .announce
                } label: {
                    Image(manager.currentTab == Tab.announce ? "" : "")
                }
                
                Button {
                    navigation.pushRoot()
                    manager.currentTab = .setting
                } label: {
                    Image(manager.currentTab == Tab.setting ? "" : "")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 7)
        .background(Color.balck)
        .cornerRadius(20, corner: .top)
    }
}
