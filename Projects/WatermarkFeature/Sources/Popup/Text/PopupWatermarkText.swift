//
//  PopupWatermarkText.swift
//  Plogin
//
//  Created by AtenB on 10/20/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import UISchema
import Design

struct PopupWatermarkText: View {
    @StateObject var viewModel: PopupWatermarkTextVM
    
    init(
        viewModel: PopupWatermarkTextVM
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
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
    }
    
    @ViewBuilder
    func makeContent() -> some View {
        VStack(spacing: 30) {
            Text("이미지 생성에 필요한\n워터마크 문구를 입력해주세요.")
                .font(.body2)
                .foreground(.Gray.light)
                .multilineTextAlignment(.center)
            
            BasicTextField(text: $viewModel.text, placeholder: "워터마크 문구를 입력하세요.")
                .onChange(of: viewModel.text) { _ in
                    viewModel.input()
                }
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
//    PopupWatermarkTextView(text: $text, callback: { isNext in
//        
//    })
//}
