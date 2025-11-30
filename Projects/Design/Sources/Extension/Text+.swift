//
//  Text+.swift
//  Design
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public extension Text {
    func font(_ type: FontType) -> some View {
        return self
            .font(type.font)
            .kerning(-0.25)
            .lineSpacing((type.lineHeight - type.size)/2)
            .padding(.vertical, (type.lineHeight - type.size)/4)
    }
}
