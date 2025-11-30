//
//  IconLabel.swift
//  Design
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public enum IconAlignment {
    case leading
    case trailing
}

public struct IconLabel: View {
    let text: String
    let icon: Image
    let size: CGFloat
    let color: Color
    let alignment: IconAlignment
    
    public init(
        text: String,
        icon: Image,
        color: Color = .white,
        size: CGFloat = 20,
        alignment: IconAlignment = .trailing
    ) {
        self.text = text
        self.icon = icon
        self.size = size
        self.color = color
        self.alignment = alignment
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            if alignment == .leading {
                icon
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size)
                    .foreground(color)
            }
            
            Text(text)
                .font(.bold2)
                .foreground(color)
            
            if alignment == .trailing {
                icon
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size)
                    .foreground(color)
            }
        }
    }
}

