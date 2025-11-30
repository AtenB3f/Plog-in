//
//  CircleIndicator.swift
//  Design
//
//  Created by AtenB on 10/24/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct Spinner: View {
    let color: Color
    let lineWidth: CGFloat
    
    @State private var isAnimating = false
    
    public init(
        _ color: Color = .white,
        _ lineWidth: CGFloat = 3
    ) {
        self.color = color
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        Circle()
            .trim(from: 0, to: 1)
            .stroke(lineWidth: lineWidth)
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Gradient(colors: [.clear, color.opacity(0.8), color, color]))
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
//            .animation(
//                .linear(duration: 1.3)
//                .repeatForever(autoreverses: false),
//                value: isAnimating
//            )
            .onAppear { isAnimating = true }
    }
}

#Preview {
    Spinner()
        .frame(width: 20, height: 20)
}
