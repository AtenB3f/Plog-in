//
//  TitleTextOnePopup.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct TitleTextOnePopup: View {
    @Binding var isShow: Bool
    var title: String
    var text: String
    var buttonText: String
    var callback: (() -> Void)?
    
    public init(
        isShow: Binding<Bool>,
        title: String,
        text: String,
        buttonText: String,
        callback: (() -> Void)? = nil
    ) {
        self._isShow = isShow
        self.title = title
        self.text = text
        self.buttonText = buttonText
        self.callback = callback
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(title)
                .sub1()
                .foreground(.Text.light)
            
            Text(text)
                .body2()
                .foreground(.Gray.light)
                .multilineTextAlignment(.center)
            
            Button {
                callback?()
                isShow = false
            } label: {
                BlackFillBoxLabel(buttonText)
            }
            .fillBoxLabelButtonStyle()
        }
        .padding(30)
        .background(Color.Base.dark)
        .cornerRadius(8, corner: .all)
    }
}

#Preview {
    @State var isShow: Bool = true
    TitleTextOnePopup(
        isShow: $isShow,
        title: "문구등록",
        text: "처음 인증 이미지를 만드시는군요!\n이미지 생성에 필요한\n워터마크 문구를 입력해주세요.",
        buttonText: "다음", callback: {
        
    })
    .padding(30)
}
