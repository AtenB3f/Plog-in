//
//  View.swift
//  Design
//
//  Created by AtenB on 4/11/25.
//

import SwiftUI

@available(iOS 13.0, *)
public struct LazyView<Content: View>: View {
    let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}

#if os(iOS)
@available(iOS 15.0, *)
public struct HiddenNavigationBar: ViewModifier {
    public init() { }
    public func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
//            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EmptyView()
                }
            }
    }
}
#else
public struct HiddenNavigationBar: ViewModifier {
    public init() { }
    public func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
    }
}
#endif
