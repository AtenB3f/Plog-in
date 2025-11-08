//
//  FillBoxLabelButtonStyle.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//


import SwiftUI

public extension View {
    func fillBoxLabelButtonStyle() -> some View {
        return self.buttonStyle(FillBoxLabelButtonStyle())
    }
}

public struct FillBoxLabelButtonStyle: ButtonStyle {
    @State private var isHover: Bool = false

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .brightness(isHover ? 0.1 : 0)
            .scaleEffect(configuration.isPressed ? 0.976 : 1.0)
            .onHover { isOn in
                isHover = isOn
            }
    }
}

#Preview {
    Button {
        
    } label: {
        GrayFillBoxLabel("취소")
    }
    .fillBoxLabelButtonStyle()
    
        .frame(width: 100)
    Button {
        
    } label: {
        BlackFillBoxLabel("취소")
    }
    .fillBoxLabelButtonStyle()
    .frame(width: 100)
}
