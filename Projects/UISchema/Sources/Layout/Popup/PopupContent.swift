//
//  PopupContent.swift
//  UISchema
//
//  Created by AtenB on 4/30/26.
//

import SwiftUI

// MARK: - Content
public enum PopupContentLayout {
    case none
    case description
    case view
}

public protocol PopupContent {
    func eraseToAnyView() -> AnyView
}

public struct PopupContentNone: PopupContent {
    public init() {}
    public func eraseToAnyView() -> AnyView {
        AnyView(EmptyView())
    }
}

public struct PopupContentDescription: PopupContent {
    public init(
        description: String
    ) {
        self.description = description
    }
    
    public var description: String
    
    public func eraseToAnyView() -> AnyView {
        AnyView(EmptyView())
    }
}

public struct PopupContentView<Content: View>: PopupContent {
    public init(
        @ViewBuilder content: () -> Content
    ) {
        self.view = content()
    }
    
    public var view: Content
    
    public func eraseToAnyView() -> AnyView {
        AnyView(view)
    }
}
