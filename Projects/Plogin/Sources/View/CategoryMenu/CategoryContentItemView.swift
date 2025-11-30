//
//  CategoryContentItemView.swift
//  Plogin
//
//  Created by AtenB on 11/26/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct CategoryContentItemView<Content>: View where Content: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body1)
                .foreground(.Text.dark)
                .frame(width: 80, alignment: .leading)
                .padding(.vertical, 5)
            
            Spacer()
            
            content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}
