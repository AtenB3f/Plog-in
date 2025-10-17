//
//  NavigationLayout.swift
//  Design
//
//  Created by AtenB on 4/11/25.
//

import SwiftUI

@available(iOS 16.0, *)
public struct NavigationRootLayout<Content>: View where Content: View {
    @Binding var path: NavigationPath
    var backgroundColor: Color
    var isFullBackground: Bool
    var content: Content

    public init(
        path: Binding<NavigationPath>,
        _ color: Color = .white,
        _ isFullBackground: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._path = path
        self.backgroundColor = color
        self.isFullBackground = isFullBackground
        self.content = content()
    }

    public var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if isFullBackground {
                    backgroundColor
                        .ignoresSafeArea()
                } else {
                    backgroundColor
                }
                content
            }
        }
    }
}

#if os(iOS)
@available(iOS 16.0, *)
public struct NavigationLayout<Content>: View where Content: View {
    var backgroundColor: Color
    var isFullBackground: Bool
    var content: Content

    public init(
        _ color: Color = .white,
        _ isFullBackground: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = color
        self.isFullBackground = isFullBackground
        self.content = content()
    }

    public var body: some View {
        NavigationStack {
            if isFullBackground {
                content
                    .hiddenNavigationBarStyle()
                    .background(backgroundColor)
                    .ignoresSafeArea()
            } else {
                content
                    .hiddenNavigationBarStyle()
                    .background(backgroundColor)
            }
        }
    }
}

@available(iOS 13.0, *)
public struct ResetNavigationBar: ViewModifier {
    public init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    public func body(content: Content) -> some View {
        content
    }
}

#elseif os(macOS)
public struct NavigationLayout<Content>: View where Content: View {
    var backgroundColor: Color
    var isFullBackground: Bool
    var content: Content

    public init(_ color: Color = .white,
                _ isFullBackground: Bool = true,
                @ViewBuilder content: () -> Content) {
        self.backgroundColor = color
        self.isFullBackground = isFullBackground
        self.content = content()
    }

    public var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(backgroundColor)
    }
}
#endif

//#Preview {
//    @State var path = NavigationPath()
//    NavigationRootLayout(path: $path, .black, true) {
//
//    }
//    NavigationLayout(.blue, false) {
//            Color.white
//    }
//}
