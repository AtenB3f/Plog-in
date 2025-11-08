//
//  ContentOnePopup.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct ContentOnePopup<Content: View>: View {
    @Binding var isShow: Bool
    var buttonText: String
    var content: Content
    var callback: (() -> Void)?
    
    public init(
        isShow: Binding<Bool>,
        buttonText: String,
        @ViewBuilder content: () -> Content,
        callback: (() -> Void)? = nil
    ) {
        self._isShow = isShow
        self.buttonText = buttonText
        self.content = content()
        self.callback = callback
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            content
            
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
    ContentOnePopup(
        isShow: $isShow,
        buttonText: "다음",
        content: {
        Text("처음 인증 이미지를 만드시는군요!\n이미지 생성에 필요한\n워터마크 문구를 입력해주세요.")
            .body2()
    }, callback: {
        
    })
    .padding(30)
}
