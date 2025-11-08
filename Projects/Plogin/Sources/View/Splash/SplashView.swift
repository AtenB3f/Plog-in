//
//  SplashView.swift
//  Plogin
//
//  Created by AtenB on 11/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct SplashView: View {
    @StateObject var manager = AppManager.shared
    
    @State var opacity: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.Base.dark.opacity(opacity)
            VStack(spacing: 10) {
                Image("Logo_Image")
                Image("Logo_Name")
            }
        }
        .ignoresSafeArea(.all)
        .task {
            do {
                try await Task.sleep(for: .seconds(1.5))
                withAnimation {
                    opacity = .zero
                    manager.rootView = .navigation
                }
            } catch {}
        }
    }
}

//#Preview {
//    SplashView()
//}
