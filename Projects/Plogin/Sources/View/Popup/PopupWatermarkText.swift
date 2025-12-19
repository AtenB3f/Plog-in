//
//  PopupWatermarkText.swift
//  Plogin
//
//  Created by AtenB on 10/20/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct PopupWatermarkText: View {
    @Binding var text: String
    let description: String
    let left: String
    let right: String
    let callback: (Bool)->Void
    
    init(
        text: Binding<String>,
        description: String = "이미지 생성에 필요한\n워터마크 문구를 입력해주세요.",
        left: String = "취소",
        right: String = "다음",
        callback: @escaping (Bool) -> Void
    ) {
        self._text = text
        self.description = description
        self.left = left
        self.right = right
        self.callback = callback
    }
    
    var body: some View {
        TitleContentTwoPopup(
            title: "문구등록",
            leftText: left,
            rightText: right,
            content: {
                VStack(spacing: 30) {
                    Text(description)
                        .font(.body2)
                        .foreground(.Gray.light)
                        .multilineTextAlignment(.center)
                    
                    BasicTextField(text: $text, placeholder: "워터마크 문구를 입력하세요.")
                }
                .padding(.vertical)
            }
        ) { isNext in
            callback(isNext)
        }
        .padding(.horizontal, 30)
    }
}

//#Preview {
//    @State var text: String = ""
//    PopupWatermarkTextView(text: $text, callback: { isNext in
//        
//    })
//}
