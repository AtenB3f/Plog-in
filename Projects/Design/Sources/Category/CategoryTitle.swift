//
//  CategoryTitle.swift
//  Plogin
//
//  Created by AtenB on 12/3/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct CategoryTitle: View {
    let title: String
    
    public init(
        _ title: String
    ) {
        self.title = title
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.body1)
                .foreground(.Text.dark)
                .frame(width: 80, alignment: .leading)
                .padding(.vertical, 5)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}
