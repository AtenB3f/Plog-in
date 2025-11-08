//
//  Skeleton.swift
//  Design
//
//  Created by AtenB on 10/24/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct SkeletonView: View {
    let backgroundColor: Color
    let text: String?
    
    private let duration: CGFloat = 2.6
    private let colors: [Color] = [.Yejun.disable, .Noah.disable, .Bamby.disable, .Eunho.disable, .Hamin.disable]
    @State private var current: Color = .Yejun.disable
    @State private var isAnimating = false
    @State private var index: Int = 0
    @State private var width: CGFloat = .zero
    @State private var height: CGFloat = .zero
    @State private var count: Int = 0
    @State private var dots: String = ""
    
    public init(
        _ backgroundColor: Color = .Base.dark,
        text: String? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.text = text
    }
    
    public var body: some View {
        GeometryReader { proxy in
            backgroundColor
            LinearGradient(
                colors: [.clear, colors[index], .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .blur(radius: 100)
                .rotationEffect(.degrees(-30))
                .offset(x: isAnimating ? width : -width,
                        y: isAnimating ? height:  -height)
                .onAppear {
                    self.width = proxy.size.width*1.3
                    self.height = proxy.size.height/1.2
                    withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                        isAnimating.toggle()
                        print(isAnimating)
                        
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
                        if index < colors.count - 1 {
                            index += 1
                        } else {
                            index = 0
                        }
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
                        if count < 3{
                            count += 1
                            dots += "."
                        } else if count < 4 {
                            count += 1
                        } else {
                            count = 0
                            dots = ""
                        }
                    }
                }
            if let text = text{
                Text(text+dots)
                    .body2()
                    .foreground(.Text.medium)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
        }
        .clipped()
    }
}

//#Preview {
//    SkeletonView(.Base.dark, text: "이미지 생성 중")
//        .frame(height: 200)
//}
