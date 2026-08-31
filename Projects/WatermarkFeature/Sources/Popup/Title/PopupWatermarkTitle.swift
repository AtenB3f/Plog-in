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
    @FocusState var isFocusField: Bool
    
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
        BasicTextField(
            text: $viewModel.text,
            placeholder: "제목을 입력하세요."
        )
        .focused($isFocusField, equals: true)
        .onSubmit { viewModel.action(.confirm) }
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
            BlackFillBoxLabel("변경")
        }
    }
}
