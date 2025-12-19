//
//  FoldingModifier.swift
//  Design
//
//  Created by AtenB on 12/4/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct FoldingHeightModifier: ViewModifier {
    var isShow: Bool
    @State private var height: CGFloat?
    
    public func body(content: Content) -> some View {
        content
            .frame(height: height)
            .clipped()
            .onChange(of: isShow) {
                withAnimation {
                    height = isShow ? nil : 0
                }
            }
            .allowsHitTesting(isShow)
            .onAppear { height = isShow ? nil : 0}
    }
}
public extension View {
    func foldingHeight(_ isShow: Bool) -> some View {
        self.modifier(FoldingHeightModifier(isShow: isShow))
    }
}
