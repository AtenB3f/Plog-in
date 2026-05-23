//
//  TabBarView.swift
//  IPBOX
//
//  Created by AtenB on 7/16/25.
//  Copyright © 2025 metaparts. All rights reserved.
//

import SwiftUI
import Design

struct TabBarView: View {
    @StateObject var manager = AppManager.shared
    
    var body: some View {
        // Bottom Tabbar List
        VStack(spacing: 0) {
            HStack(spacing: 60) {
                Button {
                    manager.currentTab = .home
                } label: {
//                    Image(manager.currentTab == Tab.connect ? "" : "")
                }
                
                Button {
//                    manager.currentTab = .announce
                } label: {
//                    Image(manager.currentTab == Tab.announce ? "" : "")
                }
                
                Button {
//                    manager.currentTab = .setting
                } label: {
//                    Image(manager.currentTab == Tab.setting ? "" : "")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 7)
        .cornerRadius(20, corner: .top)
    }
}
