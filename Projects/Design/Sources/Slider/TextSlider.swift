//
//  TextSlider.swift
//  Design
//
//  Created by AtenB on 11/26/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Foundation

public struct TextSlider: View {
    @Binding var value: CGFloat
    let minValue: CGFloat
    let maxValue: CGFloat
    let distance: CGFloat
    
    @State private var width: CGFloat = .zero
    @State private var isPress: Bool = false
    
    public init(
        value: Binding<CGFloat>,
        min: CGFloat,
        max: CGFloat,
        distance: CGFloat = 0.05
    ) {
        self._value = value
        self.minValue = min
        self.maxValue = max
        self.distance = distance
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .foreground(.white.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: isPress ? 15 : 8)
                
                RoundedRectangle(cornerRadius: 10)
                    .foreground(.Text.light)
                    .frame(width: width, height: isPress ? 15 : 8)
                    
            }
            .onAppear {
                width = value * geometry.size.width / (maxValue - minValue)
            }
            .gesture(
                DragGesture(minimumDistance: distance)
                    .onChanged { gesture in
                        isPress = true
                        if gesture.location.x >= geometry.size.width {
                            width = geometry.size.width
                        } else if gesture.location.x <= 0 {
                            width = .zero
                        } else {
                            width = gesture.location.x
                        }
                        value = width / geometry.size.width * (maxValue - minValue)
                    }
                    .onEnded { _ in
                        isPress = false
                    }
            )
        }
        .frame(height: isPress ? 15 : 8)
        .animation(.easeInOut(duration: 0.2), value: isPress)
    }
}

//#Preview {
//    @State var value: CGFloat = 10
//    TextSlider(value: $value, min: 0, max: 100)
//        .padding(20)
//        .background(Color.black)
//}
