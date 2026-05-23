//
//  Popup.swift
//  Design
//
//  Created by AtenB on 4/30/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI
import UISchema

public struct Popup: View, PopupLayout {
    public var headerType: PopupHeaderLayout
    public var contentType: PopupContentLayout
    public var buttonType: PopupButtonLayout
    
    public var header: any UISchema.PopupHeader
    public var content: any UISchema.PopupContent
    public var button: any UISchema.PopupButton

    public init(layout: PopupLayout) {
        self.headerType = layout.headerType
        self.contentType = layout.contentType
        self.buttonType = layout.buttonType
        self.header = layout.header
        self.content = layout.content
        self.button = layout.button
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            PopupHeaderRender(type: headerType, header: header)
            PopupContentRender(type: contentType, content: content)
            PopupButtonRender(type: buttonType, content: button)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
        .padding(.vertical, 30)
        .background(Color.Base.dark)
        .cornerRadius(8, corner: .all)
    }
}

struct PopupHeaderRender: View {
    var type: PopupHeaderLayout
    var title: PopupHeaderTitle?
    
    init(
        type: PopupHeaderLayout,
        header: any UISchema.PopupHeader
    ) {
        self.type = type
        if type == .title {
            self.title = header as? PopupHeaderTitle
        }
    }
    
    var body: some View {
        if let title = title?.title, type == .title {
            Text(title)
                .font(.sub1)
                .foreground(.white)
        }
    }
}

struct PopupContentRender: View {
    var type: PopupContentLayout
    var content: any UISchema.PopupContent
    
    init(
        type: PopupContentLayout,
        content: any UISchema.PopupContent
    ) {
        self.type = type
        self.content = content
    }
    
    var body: some View {
        switch type {
        case .description:
            if let description = content as? PopupContentDescription {
                Text(description.description)
                    .font(.body2)
                    .foreground(.Gray.light)
            }
        default:
            content.eraseToAnyView()
        }
    }
}

struct PopupButtonRender: View {
    var type: PopupButtonLayout
    var content: any PopupButton
    
    init(
        type: PopupButtonLayout,
        content: any UISchema.PopupButton
    ) {
        self.type = type
        self.content = content
    }
    
    var body: some View {
        switch type {
        case .two:
            if let two = content as? PopupButtonTwo {
                switch two.alignment {
                case .horizonatal:
                    HStack {
                        two.first
                        two.second
                    }
                case .vertical:
                    VStack {
                        two.first
                        two.second
                    }
                }
            }
        default:
            content.eraseToAnyView()
        }
    }
}

struct PopupTest: PopupLayout {
    var headerType: UISchema.PopupHeaderLayout = .title
    var contentType: UISchema.PopupContentLayout = .view
    var buttonType: UISchema.PopupButtonLayout = .two
    
    var header: any UISchema.PopupHeader = PopupHeaderTitle(title: "제목없음")
    var content: any UISchema.PopupContent = PopupContentView {
        Image(systemName: "star")
            .resizable()
            .frame(width: 140, height: 140)
    }
    var button: any UISchema.PopupButton = PopupButtonTwo(alignment: .vertical) {
        Button {
            print("1")
        } label: {
            Text("1")
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .padding(.vertical)
                .background(Color.white)
        }
    } second: {
        Button {
            print("2")
        } label: {
            Text("2")
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .padding(.vertical)
                .background(Color.white)
        }
    }
}

#Preview {
    Popup(layout: PopupTest())
}
