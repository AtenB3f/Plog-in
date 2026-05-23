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
    init() {
        FontLoader.loadModuleFont()
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
