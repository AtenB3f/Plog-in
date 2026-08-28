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
import PlatformExport

public struct PopupWatermarkPreview: View {
    @StateObject var viewModel: PopupWatermarkPreviewVM
    let wateramrkVM: WatermarkViewModel
    
    public init(
        viewModel: PopupWatermarkPreviewVM,
        wateramrkVM: WatermarkViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.wateramrkVM = wateramrkVM
    }
    
    public var body: some View {
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
                viewModel.action(.appear)
            }
            .fullScreenCover(isPresented: $viewModel.isShowPicker) {
                viewModel.action(.select)
            } content: {
                AssetPickerView(picker: viewModel.picker)
            }
    }
}

extension PopupWatermarkPreview {
    @ViewBuilder
    func makeContent() -> some View {
        VStack(spacing: 20) {
            Color.clear
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, alignment: .center)
                .overlay {
                    WatermarkView(viewModel: wateramrkVM)
                }
                .cornerRadius(4, corner: .all)
                
            HStack {
                Text("문구")
                    .font(.body1)
                    .foreground(.Gray.medium)
                Spacer()
                
                Button {
                    viewModel.action(.input)
                } label: {
                    IconLabel(
                        text: viewModel.store.watermark.text.text,
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
