//
//  PopupWatermarkInputWord.swift
//  Plogin
//
//  Created by AtenB on 12/18/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import UISchema
import Design

public struct PopupWatermarkTitle: View {
    @StateObject var viewModel: PopupWatermarkTitleVM
    
    public init(
        viewModel: PopupWatermarkTitleVM
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    public var body: some View {
        Popup(layout: viewModel)
            .task {
                viewModel.setHeader(type: .title, header: PopupHeaderTitle(title: "제목 변경"))
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
        BasicTextField(text: $viewModel.title, placeholder: "제목을 입력하세요.")
        .padding(.vertical)
        .onChange(of: viewModel.title) {
            viewModel.action(.input)
        }
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
            BlackFillBoxLabel("변경")
        }
    }
}
