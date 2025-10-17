//
//  LineDivider.swift
//  Design
//
//  Created by AtenB on 4/15/25.
//

import SwiftUI

public struct LineDivider: View {
    public init(color: Color,
                height: CGFloat = 1) {
        self.color = color
        self.height = height
    }
    public var color: Color
    public var height: CGFloat

    public var body: some View {
        Rectangle()
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .foreground(color)
    }
}

//#Preview {
//    LineDivider(color: .red, height: 2)
//}
