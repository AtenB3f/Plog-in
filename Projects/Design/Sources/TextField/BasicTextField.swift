//
//  BasicTextField.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

@available(iOS 16.0, *)
public struct BasicTextField: View {
    @Binding var text: String
    let placeholder: String
    @FocusState private var isFocused: Bool

    public init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }
    
    public var body: some View {
        HStack(spacing: 6) {
            TextField(text: $text) {
                Text(placeholder)
                    .font(.body2)
                    .foreground(.Gray.disable)
                    .lineLimit(1)
            }
            .body2()
            .foreground(.Text.light)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .lineLimit(1)
            .frame(height: 20)

            Button {
                isFocused = false
                text = ""
            } label: {
                Image.iconCloseMD
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foreground(.Gray.medium)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color.Base.dark)
        .cornerRadius(4, corner: .all)
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(lineWidth: 1)
                .foreground(.Gray.disable)
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    ZStack {
        Color.Base.dark
        
        BasicTextField(
            text: $text,
            placeholder: "워터마크 문구를 입력하세요."
        )
        .padding(30)
    }
}
