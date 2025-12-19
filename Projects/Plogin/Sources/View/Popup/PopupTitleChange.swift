//
//  PopupTitleChange.swift
//  Plogin
//
//  Created by AtenB on 12/18/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct PopupTitleChange: View {
    private let manager = AppManager.shared
    @Binding var text: String
    let callback: (String?)->Void
    
    init(text: Binding<String>,
         callback: @escaping (String?) -> Void) {
        self._text = text
        self.callback = callback
    }
    var body: some View {
        TitleContentTwoPopup(
            title: "제목 변경",
            leftText: "취소",
            rightText: "변경",
            content: {
                BasicTextField(text: $text, placeholder: "제목을 입력하세요.")
                .padding(.vertical)
            }
        ) { isRight in
            callback(isRight ? text : nil)
            manager.pushPopup()
        }
        .padding(.horizontal, 30)
    }
}
