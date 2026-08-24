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
                width = widthForValue(value, in: geometry.size.width)
            }
            .onChange(of: value) {
                width = widthForValue(value, in: geometry.size.width)
            }
            .gesture(
                DragGesture(minimumDistance: distance)
                    .onChanged { gesture in
                        isPress = true
                        let clampedX = min(max(gesture.location.x, 0), geometry.size.width)
                        let rawValue = minValue + (clampedX / geometry.size.width) * (maxValue - minValue)
                        let steppedValue = minValue + ((rawValue - minValue) / distance).rounded() * distance
                        let clampedValue = min(max(steppedValue, minValue), maxValue)
                        value = clampedValue
                        width = widthForValue(clampedValue, in: geometry.size.width)
                    }
                    .onEnded { _ in
                        isPress = false
                    }
            )
        }
        .frame(height: isPress ? 15 : 8)
        .animation(.easeInOut(duration: 0.2), value: isPress)
    }

    private func widthForValue(_ value: CGFloat, in totalWidth: CGFloat) -> CGFloat {
        guard maxValue > minValue else { return 0 }
        let clampedValue = min(max(value, minValue), maxValue)
        return (clampedValue - minValue) / (maxValue - minValue) * totalWidth
    }
}

#Preview {
    @State var value: CGFloat = 10
    TextSlider(value: $value, min: 0, max: 100)
        .padding(20)
        .background(Color.black)
}
