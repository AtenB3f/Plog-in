//
//  CircleIndicator.swift
//  Design
//
//  Created by AtenB on 10/24/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

struct Spinner: View {
    let color: Color
    
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 1)
            .stroke(lineWidth: 3)
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Gradient(colors: [.clear, color.opacity(0.8), color, color]))
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 1.3)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear { isAnimating = true }
    }
}

//#Preview {
//    Spinner(color: .Yejun.disable)
//        .frame(width: 20, height: 20)
//}
