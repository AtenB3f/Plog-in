//
//  PopupViewModel.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/2/26.
//

import SwiftUI

open class PopupViewModel: PopupLayout, ObservableObject {
    @Published public var headerType: UISchema.PopupHeaderLayout = .none
    @Published public var contentType: UISchema.PopupContentLayout = .none
    @Published public var buttonType: UISchema.PopupButtonLayout = .none
    
    @Published public var header: any UISchema.PopupHeader = PopupHeaderNone()
    @Published public var content: any UISchema.PopupContent = PopupContentNone()
    @Published public var button: any UISchema.PopupButton = PopupButtonNone()
    
    public init(
        headerType: UISchema.PopupHeaderLayout = .none,
        contentType: UISchema.PopupContentLayout = .none,
        buttonType: UISchema.PopupButtonLayout = .none,
        header: any UISchema.PopupHeader = PopupHeaderNone(),
        content: any UISchema.PopupContent = PopupContentNone(),
        button: any UISchema.PopupButton = PopupButtonNone()
    ) {
        self.headerType = headerType
        self.contentType = contentType
        self.buttonType = buttonType
        self.header = header
        self.content = content
        self.button = button
    }
}

@MainActor
public extension PopupViewModel {
    func setLayout(
        headerType: UISchema.PopupHeaderLayout,
        contentType: UISchema.PopupContentLayout,
        buttonType: UISchema.PopupButtonLayout,
        header: any UISchema.PopupHeader,
        content: any UISchema.PopupContent,
        button: any UISchema.PopupButton
    ) {
        self.headerType = headerType
        self.contentType = contentType
        self.buttonType = buttonType
        self.header = header
        self.content = content
        self.button = button
    }
    
    func setHeader(type: UISchema.PopupHeaderLayout, header: any UISchema.PopupHeader) {
        self.headerType = type
        self.header = header
    }
    
    func setContent(type: UISchema.PopupContentLayout, content: any UISchema.PopupContent) {
        self.contentType = type
        self.content = content
    }
    
    func setButton(type: UISchema.PopupButtonLayout, button: any UISchema.PopupButton) {
        self.buttonType = type
        self.button = button
    }
}
