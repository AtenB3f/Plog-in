//
//  PopupWatermarkPreview.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Combine
import UISchema
import Design

struct PopupWatermarkPreview: View {
//    @StateObject private var manager = AppManager.shared
//    private let dataManager = DataStore.shared
//    @StateObject var viewModel = PopupWatermarkPreviewViewModel()
//    @FocusState var isFocus: Bool
//    let watermark: WatermarkModel
    
//    init(watermark: WatermarkModel) {
//        self.watermark = watermark
//    }
    @StateObject var viewModel: PopupWatermarkPreviewVM
    
    init(
        viewModel: PopupWatermarkPreviewVM
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Popup(layout: viewModel)
            .task {
                viewModel.setHeader(type: .title, header: PopupHeaderTitle(title: "미리보기"))
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
}

extension PopupWatermarkPreview {
    @ViewBuilder
    func makeContent() -> some View {
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
            BlackFillBoxLabel("저장")
        }
    }
}

