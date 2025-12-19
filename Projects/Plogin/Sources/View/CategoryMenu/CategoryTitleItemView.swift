//
//  CategoryTitleItemView.swift
//  Plogin
//
//  Created by AtenB on 12/3/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct CategoryTitleItemView: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body1)
                .foreground(.Text.dark)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}
