//
//  AppManager.swift
//  Plogin
//
//  Created by AtenB on 9/20/25.
//  Copyright © 2025 Plli. All rights reserved.
//

final class AppManager: ObservableObject {
    
    @Published var isRootPopup: Bool = false
    @Published var rootPopup: PopupType?
    
    @Published var rootView: RootStatus = .splash
    
    @Published var currentTab: Tab = .connect

    func pushPopup(_ type: PopupType? = nil) {
        isRootPopup = type != nil
        rootPopup = type
    }
    
}
