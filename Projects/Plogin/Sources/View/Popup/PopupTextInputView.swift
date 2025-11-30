//
//  PopupTextInputView.swift
//  Plogin
//
//  Created by AtenB on 11/10/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

//struct PopupTextInputView: View {
//    @Binding var text: String
//    let callback: (Bool)->Void
//    
//    init(
//        text: Binding<String>,
//        callback: @escaping (Bool) -> Void) {
//        self._text = text
//        self.callback = callback
//    }
//    
//    var body: some View {
//        TitleContentTwoPopup(
//            title: "문구등록",
//            leftText: "취소",
//            rightText: "다음",
//            content: {
//                VStack(spacing: 30) {
//                    Text("이미지 생성에 필요한\n워터마크 문구를 입력해주세요.")
//                        .font(.body2)
//                        .foreground(.Gray.light)
//                        .multilineTextAlignment(.center)
//                    
//                    BasicTextField(text: $text, placeholder: "워터마크 문구를 입력하세요.")
//                }
//                .padding(.vertical)
//            }
//        ) { isNext in
//            callback(isNext)
//        }
//        .padding(.horizontal, 30)
//    }
//}
