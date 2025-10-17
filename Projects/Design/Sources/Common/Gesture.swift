//
//  Gesture.swift
//  Design
//
//  Created by eone on 8/4/25.
//

import SwiftUI

@available(iOS 13.0, *)
public extension View {
    func dismissGesture(_ callback: @escaping () -> Void) -> some View {
        self.modifier(DismissGestureModifier(callback: callback))
    }
}

@available(iOS 13.0, *)
public struct DismissGestureModifier: ViewModifier {
    @GestureState private var dragOffset = CGSize.zero
    let callback: () -> Void

    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        if value.translation.width > 100 {
                            callback()
                        }
                    }
            )
    }
}

