//
//  WatermarkEditView.swift
//  Plogin
//
//  Created by AtenB on 8/9/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Design

struct WatermarkEditView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = WatermarkEditViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitle(
                title: "워터마크 편집",
                leftIcon: .iconCloseMD,
                rightIcon: .iconSave, callback: { isRight in
                if isRight {
                    viewModel.saveWatermarkImage()
                    dismiss()
                } else {
                    dismiss()
                }
            })
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(Array(viewModel.previews), id: \.self) { image in
                        VStack {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .padding(10)
            .task {
                viewModel.pushPicker(.watermark)
            }
            
            WatermarkEditMenuView()
                .environmentObject(viewModel)
        }
        .background(Color.black)
        .fullScreenCover(isPresented: $viewModel.isShowPicker, onDismiss: {
            guard let type = viewModel.pickerType else { return }
            viewModel.loadImages()
            viewModel.autoSetting()
            viewModel.makePreview()
        }) {
            if let type = viewModel.pickerType {
                switch type {
                case .watermark:
                    AssetPickerView(avAsset: $viewModel.assets,
                                    type: type.mediaType,
                                    limit: type.maxCount)
                case .sticker:
                    AssetPickerView(avAsset: $viewModel.stickerAsset,
                                    type: type.mediaType,
                                    limit: type.maxCount)
                }
            }
        }
    }
}
