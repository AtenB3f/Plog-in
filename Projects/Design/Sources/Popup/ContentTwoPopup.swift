//
//  ContentTwoPopup.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct ContentTwoPopup<Content: View>: View {
    @Binding var isShow: Bool
    var leftText: String
    var rightText: String
    var content: Content
    var callback: ((Bool) -> Void)?
    
    public init(
        isShow: Binding<Bool>,
        leftText: String,
        rightText: String,
        @ViewBuilder content: () -> Content,
        callback: ((Bool) -> Void)? = nil
    ) {
        self._isShow = isShow
        self.leftText = leftText
        self.rightText = rightText
        self.content = content()
        self.callback = callback
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            content
            
            HStack {
                Button {
                    callback?(false)
                    isShow = false
                } label: {
                    GrayFillBoxLabel(leftText)
                }
                .fillBoxLabelButtonStyle()
                
                Button {
                    callback?(true)
                    isShow = false
                } label: {
                    BlackFillBoxLabel(rightText)
                }
                .fillBoxLabelButtonStyle()
            }
        }
        .padding(30)
        .background(Color.Base.dark)
        .cornerRadius(8, corner: .all)
    }
}

#Preview {
    @State var isShow: Bool = true
    ContentTwoPopup(
        isShow: $isShow,
        leftText: "취소",
        rightText: "다음",
        content: {
        Text("처음 인증 이미지를 만드시는군요!\n이미지 생성에 필요한\n워터마크 문구를 입력해주세요.")
        }, callback: { _ in
        
    })
    .padding(30)
}
