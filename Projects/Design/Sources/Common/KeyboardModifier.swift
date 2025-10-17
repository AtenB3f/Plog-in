//
//  KeyboardModifier.swift
//  Design
//
//  Created by AtenB on 4/16/25.
//

import SwiftUI
import Combine

#if os(iOS)
@available(iOS 13.0, *)
public struct KeyboardAwareModifier: ViewModifier {
    public init() { }

    @State private var keyboardHeight: CGFloat = 0

    private var keyboardHeightPublisher: AnyPublisher <CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    public func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .edgesIgnoringSafeArea(keyboardHeight == 0 ? [] :.bottom)
            .onReceive(keyboardHeightPublisher) {
                self.keyboardHeight = $0
            }
            .animation(.easeOut(duration: 0.16), value: keyboardHeight)
    }
}

@available(iOS 13.0, *)
public struct KeyboardRecevierModifier: ViewModifier {
    public init(keyboardHeight: Binding<CGFloat>) {
        self._keyboardHeight = keyboardHeight
    }

    @Binding var keyboardHeight: CGFloat

    private var keyboardHeightPublisher: AnyPublisher <CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    public func body(content: Content) -> some View {
        content
            .onReceive(keyboardHeightPublisher) {
                self.keyboardHeight = $0
            }
    }
}
#endif
