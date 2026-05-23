//
//  CategoryButton.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct CategoryButton: View {
    let title: String
    let button: String
    let onClick: () -> Void
    
    public init(
        title: String,
        button: String,
        onClick: @escaping () -> Void
    ) {
        self.title = title
        self.button = button
        self.onClick = onClick
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.body1)
                .foreground(.Text.dark)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            Button {
                onClick()
            } label: {
                HStack(spacing: 0) {
                    Text(button)
                        .font(.bold1)
                        .foreground(.Text.light)
                    
                    Image.iconChevronRightSM
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foreground(.Text.light)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}
