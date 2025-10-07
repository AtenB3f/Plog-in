//
//  TabNavigationVIew.swift
//  IPBox
//
//  Created by AtenB on 4/15/25.
//  Copyright © 2025 eone. All rights reserved.
//

import SwiftUI

struct TabNavigationView: View {
    @EnvironmentObject var manager: AppManager

    @StateObject var navigation = TabNavigationViewModel()
    

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HeaderView()
                
                NavigationRootLayout(path: $navigation.path) {
                    VStack(spacing: 0) {
                        switch manager.currentTab {
                        case .connect:
                            if manager.userMemberType == "sub" {
                                VPNDetailView(manager.username)
                                    .environmentObject(navigation)
                            } else if manager.userMemberType == "main" {
                                VPNListView()
                                    .environmentObject(navigation)
                            }
                            
                        case .announce:
                            AnnounceListView()
                                .environmentObject(navigation)
                            
                        case .setting:
                            SettingView()
                                .environmentObject(navigation)
                        }
                    }
                    .hiddenNavigationBarStyle()
                    .navigations(navigation)
                }
            }
            
            TabBarView()
                .environmentObject(navigation)
                .environmentObject(manager)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {if let memberType = dataManager.getUserMemberType(),
                !memberType.isEmpty {
                manager.userMemberType = memberType
            } else {
                manager.userMemberType = "sub"
            }
        }
        .task {
            if manager.username.isEmpty {
                manager.username = await manager.requestMemberID() ?? ""
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .pushPopup)) { notification in
            if let type = notification.object as? PopupType {
                manager.pushPopup(type)
            } else {
                manager.pushPopup()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .logout)) { _ in
            manager.logout()
        }
    }
}

//#Preview {
//    TabNavigationVIew()
//}
