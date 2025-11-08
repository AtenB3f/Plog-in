//
//  PopupWatermarkTextView.swift
//  Plogin
//
//  Created by AtenB on 10/20/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct PopupWatermarkTextView: View {
    @StateObject var manager = AppManager.shared
    
    @State private var text: String = ""
    var body: some View {
        TitleContentTwoPopup(
            isShow: $manager.isRootPopup,
            title: "문구등록",
            leftText: "취소",
            rightText: "다음",
            content: {
                VStack(spacing: 30) {
                    Text("처음 인증 이미지를 만드시는군요!\n이미지 생성에 필요한\n워터마크 문구를 입력해주세요.")
                        .body2()
                        .foreground(.Gray.light)
                        .multilineTextAlignment(.center)
                    
                    BasicTextField(text: $text, placeholder: "워터마크 문구를 입력하세요.")
                }
            }
        ) { isNext in
            if isNext {
                // TODO: 로컬 저장
                manager.isRootPopup = false
            } else {
                manager.isRootPopup = false
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    @State var isShow = false
    PopupWatermarkTextView()
}
