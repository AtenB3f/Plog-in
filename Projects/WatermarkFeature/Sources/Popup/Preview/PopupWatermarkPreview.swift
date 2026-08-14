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

public struct PopupWatermarkPreview: View {
    @StateObject var viewModel: PopupWatermarkPreviewVM
    
    public init(
        viewModel: PopupWatermarkPreviewVM
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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

