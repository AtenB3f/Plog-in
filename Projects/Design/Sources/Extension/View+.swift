//
//  View+.swift
//  Design
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
public extension View {
    // MARK: Border
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }

    func cornerRadius(_ radius: CGFloat, corner: Corner) -> some View {
        clipShape(RoundedCorner(radius: radius, corner: corner))
    }

    // MARK: Navigation Style
    func hiddenNavigationBarStyle() -> some View {
        return modifier( HiddenNavigationBar() )
    }

    // MARK: Navigation Destination
    func destination<Content>(
        _ showNavigation: Binding<Bool>,
        @ViewBuilder content: () -> Content) -> some View where Content: View {
            let contents = content()
            if #available(iOS 16, *) {
                return self
                    .navigationDestination(isPresented: showNavigation) {
                        LazyView(contents)
                }
            } else {
                return self
                    .background(
                        NavigationLink(destination: LazyView(contents),
                                       isActive: showNavigation) {
                            EmptyView()
                        }
                )
            }
    }
}

@available(iOS 13.0, *)
public extension View {
    func foreground(_ color: Color) -> some View {
#if os(macOS)
        if #available(macOS 14.0, *) {
            return self.foregroundStyle(color)
        } else {
            return self.foregroundColor(color)
        }
#else
        return self.foregroundColor(color)
#endif
    }
}

public struct RectPreferenceKey: PreferenceKey {
    public static var defaultValue: CGRect { .zero }
    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize { .zero }
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

@available(iOS 13.0, *)
public extension View {
    func getRect(in coordinateSpace: CoordinateSpace = .global, onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: RectPreferenceKey.self, value: proxy.frame(in: coordinateSpace))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let rect = proxy.frame(in: coordinateSpace)
                            onChange(rect)
                        }
                    }
            }
        )
        .onPreferenceChange(RectPreferenceKey.self, perform: onChange)
    }
}
