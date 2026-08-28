//
//  PopupButton.swift
//  UISchema
//
//  Created by AtenB on 4/30/26.
//

import SwiftUI

// MARK: - Button
public enum PopupButtonLayout {
    case none
    case one
    case two
    case content
}

public protocol PopupButton {
    func eraseToAnyView() -> AnyView
}

public struct PopupButtonNone: PopupButton {
    public init() {}
    public func eraseToAnyView() -> AnyView {
        AnyView(EmptyView())
    }
}

public struct PopupButtonOne<Content: View>: PopupButton {
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }

    public let content: () -> Content

    public func eraseToAnyView() -> AnyView {
        AnyView(content())
    }
}

public struct PopupButtonTwo: PopupButton {
    public init(
        alignment: Alignment.Perpendicular,
        @ViewBuilder first: @escaping () -> View,
        @ViewBuilder second: @escaping () -> View
    ) {
        self.alignment = alignment
        self.first = { AnyView(first()) }
        self.second = { AnyView(second()) }
    }

    public let alignment: Alignment.Perpendicular
    public let first: () -> AnyView
    public let second: () -> AnyView

    public func eraseToAnyView() -> AnyView {
        AnyView(Group { first(); second() })
    }
}

public struct PopupButtonContent<Content: View>: PopupButton {
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }

    public let content: () -> Content

    public func eraseToAnyView() -> AnyView {
        AnyView(content())
    }
}
