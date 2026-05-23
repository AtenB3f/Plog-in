//
//  PopupHeader.swift
//  UISchema
//
//  Created by AtenB on 4/30/26.
//

import SwiftUI

// MARK: - Header
public enum PopupHeaderLayout {
    case none
    case title
}

public protocol PopupHeader {
    func eraseToAnyView() -> AnyView
}

public struct PopupHeaderNone: PopupHeader {
    public init() {}
    public func eraseToAnyView() -> AnyView {
        AnyView(EmptyView())
    }
}

public struct PopupHeaderTitle: PopupHeader {
    public init(
        title: String
    ) {
        self.title = title
    }
    
    public var title: String
    
    public func eraseToAnyView() -> AnyView {
        AnyView(EmptyView())
    }
}
