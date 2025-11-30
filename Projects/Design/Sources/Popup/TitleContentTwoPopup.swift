//
//  TitleContentTwoPopup.swift
//  Design
//
//  Created by AtenB on 10/19/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI

public struct TitleContentTwoPopup<Content: View>: View {
    var title: String
    var leftText: String
    var rightText: String
    var content: Content
    var callback: ((Bool) -> Void)?
    
    public init(
        title: String,
        leftText: String,
        rightText: String,
        @ViewBuilder content: () -> Content,
        callback: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.leftText = leftText
        self.rightText = rightText
        self.content = content()
        self.callback = callback
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(title)
                .font(.sub1)
                .foreground(.Text.light)
            
            content
            
            HStack {
                Button {
                    callback?(false)
                } label: {
                    GrayFillBoxLabel(leftText)
                }
                .fillBoxLabelButtonStyle()
                
                Button {
                    callback?(true)
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
    TitleContentTwoPopup(
        title: "문구등록",
        leftText: "취소",
        rightText: "다음",
        content: {
        Text("처음 인증 이미지를 만드시는군요!\n이미지 생성에 필요한\n워터마크 문구를 입력해주세요.")
        }, callback: { _ in 
        
    })
    .padding(30)
}
