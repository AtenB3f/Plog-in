//
//  PloginApp.swift
//  Plogin
//
//  Created by AtenB on 4/16/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Design

@main
struct PloginApp: App {
    @StateObject var manager = AppManager.shared
    let dataStore = DataStore.shared
    
    init() {
        FontLoader.loadModuleFont()
        dataStore.installBasicWatermark()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

//#Preview {
//    RootView()
//}
