//
//  PopupWatermarkPreviewView.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design
import Combine

struct PopupWatermarkPreviewView: View {
    @StateObject private var manager = AppManager.shared
    private let dataManager = DataStore.shared
    @StateObject var viewModel = PopupWatermarkPreviewViewModel()
    @FocusState var isFocus: Bool
    let watermark: WatermarkModel
    
    init(watermark: WatermarkModel) {
        self.watermark = watermark
    }
    
    var body: some View {
        switch viewModel.step {
        case .picker:
            AssetPickerView(avAsset: $viewModel.assets, type: .image, limit: 1)
                .onChange(of: viewModel.assets) {
                    guard viewModel.assets.count >= 1 else { return }
                    viewModel.words = viewModel.loadWords()
                    viewModel.text = viewModel.words.first ?? ""
                    viewModel.step = viewModel.text.isEmpty ? .textInput : .preview
                }
        case .textInput:
            PopupWatermarkTextView(text: $viewModel.text) { isNext in
                if isNext {
                    viewModel.saveText()
                } else { manager.pushPopup()}
            }
        case .preview:
            ZStack {
                TitleContentTwoPopup(
                    title: "미리보기",
                    leftText: "취소",
                    rightText: "저장",
                    content: {
                        VStack(spacing: 20) {
                            Color.Gray.disable
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .cornerRadius(4, corner: .all)
                                .overlay {
                                    // thumbhnail
                                    viewModel.preview?
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            
                            HStack {
                                Text("문구")
                                    .font(.body1)
                                    .foreground(.Gray.medium)
                                Spacer()
                                
                                Button {
                                    viewModel.isShowInput = true
                                    isFocus = true
                                } label: {
                                    IconLabel(
                                        text: viewModel.text,
                                        icon: .iconChevronRightSM,
                                        color: .Text.light,
                                        size: 24
                                    )
                                }
                                .iconLabelButtonStyle()
                            }
                        }
                        .onAppear {
                            viewModel.makePreview(watermark)
                        }
                    }
                ) { isSave in
                    if isSave {
                        viewModel.saveWatermarkImate()
                        manager.pushPopup()
                    } else {
                        manager.pushPopup()
                    }
                }
                .padding(.horizontal, 30)
                
                if viewModel.isShowInput {
                    Color.Shadow.disable
                        .onTapGesture {
                            viewModel.isShowInput = false
                            isFocus = false
                        }
                    VStack(spacing: 0) {
                        Spacer()
                        VStack(spacing: 0) {
                            ScrollView(.horizontal) {
                                HStack(alignment: .center, spacing: 8) {
                                    ForEach(viewModel.words, id: \.self) { word in
                                        Button {
                                            viewModel.inputText()
                                            isFocus = false
                                        } label: {
                                            Text(word)
                                                .font(.body2)
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
                            
                            BasicTextField(text: $viewModel.text, placeholder: "워터마크 문구를 입력하세요.")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .autocorrectionDisabled()
                                .focused($isFocus)
                                .submitLabel(.return)
                                .onSubmit {
                                    viewModel.inputText()
                                    isFocus = false
                                }
                        }
                        .background(Color.Base.medium)
                    }
                    .onAppear {
                        viewModel.words.removeAll()
                        viewModel.words = viewModel.loadWords()
                        viewModel.makePreview(watermark)
                    }
                    .onChange(of: viewModel.text) {
                        viewModel.makePreview(watermark)
                    }
                }
            }
        }
    }
}
