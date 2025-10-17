//
//  VerticalDivider.swift
//  Design
//
//  Created by AtenB on 4/15/25.
//

import SwiftUI

public struct VerticalDivider: View {
    public init(color: Color,
                width: CGFloat = 1) {
        self.color = color
        self.width = width
    }
    public var color: Color
    public var width: CGFloat

    public var body: some View {
        Rectangle()
            .frame(width: width)
            .frame(maxHeight: .infinity)
            .foreground(color)
    }
}

#Preview {
    VerticalDivider(color: .red, width: 2)
}
