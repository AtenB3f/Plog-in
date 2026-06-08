//
//  PopupWatermarkWord.swift
//  Plogin
//
//  Created by AtenB on 10/20/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import UISchema
import Design

public struct PopupWatermarkWord: View {
    @StateObject var viewModel: PopupWatermarkWordVM
    @FocusState var isFocusField: Bool
    
    public init(
        viewModel: PopupWatermarkWordVM
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        Popup(layout: viewModel)
            .task {
                viewModel.setHeader(type: .title, header: PopupHeaderTitle(title: "문구등록"))
                viewModel.setContent(type: .view, content: PopupContentView { makeContent() })
                viewModel.setButton(
                    type: .two,
                    button: PopupButtonTwo(
                        alignment: .horizonatal,
                        first: { makeLeftButton() },
                        second: { makeRightButton() }
                    )
                )
            }
            .onAppear {
                viewModel.action(.appear)
            }
            .onChange(of: isFocusField) {
                viewModel.isFocusField = isFocusField
            }
            .onChange(of: viewModel.isFocusField) {
                isFocusField = viewModel.isFocusField
            }
            .onTapGesture {
                viewModel.action(.focus(false))
            }
    }
    
    @ViewBuilder
    func makeContent() -> some View {
        VStack(spacing: 30) {
            Text("이미지 생성에 필요한\n워터마크 문구를 입력해주세요.")
                .font(.body2)
                .foreground(.Gray.light)
                .multilineTextAlignment(.center)
            
            BasicTextField(
                text: $viewModel.text,
                placeholder: "워터마크 문구를 입력하세요."
            )
            .focused($isFocusField, equals: true)
            .onSubmit { viewModel.action(.confirm) }
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    func makeLeftButton() -> some View {
        Button {
            viewModel.action(.cancel)
        } label: {
            GrayFillBoxLabel("취소")
        }
    }
    
    @ViewBuilder
    func makeRightButton() -> some View {
        Button {
            viewModel.action(.confirm)
        } label: {
            BlackFillBoxLabel("다음")
        }
    }
}

//#Preview {
//    @State var text: String = ""
//    PopupWatermarkWord(text: $text, callback: { isNext in
//        
//    })
//}
