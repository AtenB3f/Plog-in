//
//  IconLabelButtonStyle.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public extension View {
    func iconLabelButtonStyle() -> some View {
        return self.buttonStyle(IconLabelButtonStyle())
    }
}

public struct IconLabelButtonStyle: ButtonStyle {
    @State private var isHover: Bool = false

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shadow(isHover ? .disable : .none)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .onHover { isOn in
                isHover = isOn
            }
    }
}

#Preview {
    Button {
        
    } label: {
        IconLabel(text: "Text",
                  icon: Image(systemName: "star"),
                  color: .Text.light
        )
    }
    .iconLabelButtonStyle()
}
