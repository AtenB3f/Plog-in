//
//  PopupWatermarkPreviewView.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct PopupWatermarkPreviewView: View {
    @StateObject private var manager = AppManager.shared
    private let dataManager = DataStore.shared
    
    @State var words: [String] = []
    @State var text: String = ""
    @State var isShowInput: Bool = false
    @FocusState var isFocus: Bool
    let watermark: WatermarkModel
    
    init(watermark: WatermarkModel) {
        self.watermark = watermark
    }
    
    var body: some View {
        ZStack {
            if text.isEmpty {
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
                        .padding(.vertical)
                    }
                ) { isNext in
                    if isNext {
                        dataManager.saveWatermarkWord(text)
                        withAnimation {
                            text = dataManager.loadWatermarkWord().first?.text ?? ""
                        }
                    } else {
                        manager.isRootPopup = false
                    }
                }
                .padding(.horizontal, 30)
            } else {
                TitleContentTwoPopup(
                    isShow: $manager.isRootPopup,
                    title: "미리보기",
                    leftText: "취소",
                    rightText: "저장",
                    content: {
                        VStack(spacing: 20) {
                            Color.Gray.disable
                                .aspectRatio(1, contentMode: .fit)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .cornerRadius(4, corner: .all)
                                .overlay {
                                    // thumbhnail
                                }
                            
                            HStack {
                                Text("문구")
                                    .body1()
                                    .foreground(.Gray.medium)
                                Spacer()
                                
                                Button {
                                    isShowInput = true
                                    isFocus = true
                                } label: {
                                    IconLabel(
                                        text: text,
                                        icon: .iconChevronRightSM,
                                        color: .Text.light,
                                        size: 24
                                    )
                                }
                                .iconLabelButtonStyle()
                            }
                        }
                    }
                ) { isSave in
                    if isSave {
                        
                    } else {
                        manager.isRootPopup = false
                    }
                }
                .padding(.horizontal, 30)
            }
            
            if isShowInput {
                Color.Shadow.disable
                    .onTapGesture {
                        isShowInput = false
                        isFocus = false
                    }
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 0) {
                        ScrollView(.horizontal) {
                            HStack(alignment: .center, spacing: 8) {
                                ForEach(words, id: \.self) { word in
                                    Button {
                                        text = word
                                        isShowInput = false
                                        isFocus = false
                                    } label: {
                                        Text(word)
                                            .body2()
                                            .foreground(.Gray.medium)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 6)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .scrollIndicators(.hidden)
                        .padding(.vertical, 4)
                        
                        BasicTextField(text: $text, placeholder: "워터마크 문구를 입력하세요.")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .autocorrectionDisabled()
                            .focused($isFocus)
                            .submitLabel(.return)
                            .onSubmit {
                                dataManager.saveWatermarkWord(text)
                                isShowInput = false
                                isFocus = false
                            }
                    }
                    .background(Color.Base.medium)
                }
            }
        }
        .onAppear {
            words = dataManager.loadWatermarkWord().map { $0.text }
            text = words.first ?? ""
        }
    }
}
