//
//  TitleTextTwoPopup.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//


import SwiftUI

public struct TitleTextTwoPopup: View {
    @Binding var isShow: Bool
    var title: String
    var text: String
    var leftText: String
    var rightText: String
    var callback: ((Bool) -> Void)?
    
    public init(
        isShow: Binding<Bool>,
        title: String,
        text: String,
        leftText: String,
        rightText: String,
        callback: ((Bool) -> Void)? = nil
    ) {
        self._isShow = isShow
        self.title = title
        self.text = text
        self.leftText = leftText
        self.rightText = rightText
        self.callback = callback
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(title)
                .font(.sub1)
                .foreground(.Text.light)
            
            Text(text)
                .font(.body2)
                .foreground(.Gray.light)
                .multilineTextAlignment(.center)
            
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
    TitleTextTwoPopup(
        isShow: $isShow,
        title: "문구등록",
        text: "처음 인증 이미지를 만드시는군요!\n이미지 생성에 필요한\n워터마크 문구를 입력해주세요.",
        leftText: "취소",
        rightText: "다음",
        callback: { _ in
        
    })
    .padding(30)
}
