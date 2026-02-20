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
    @StateObject var watermarkViewModel = WatermarkViewModel()
    let manager = AppManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitle(
                title: "워터마크 편집",
                leftIcon: .iconCloseMD,
                rightIcon: .iconSave, callback: { isRight in
                if isRight {
                    watermarkViewModel.generateResults()
                    manager.push(.watermarkResult(results: watermarkViewModel.results))
                } else {
                    dismiss()
                }
            })
            WatermarkView()
                .environmentObject(watermarkViewModel)
                .padding(10)
            
            WatermarkEditMenuView()
                .environmentObject(viewModel)
                .environmentObject(watermarkViewModel)
        }
        .frame(maxHeight: .infinity)
        .background(Color.black)
        .task {
            if watermarkViewModel.images.isEmpty {
                viewModel.pushPicker(.watermark)
            }
        }
        .onChange(of: watermarkViewModel.stickers) {
            viewModel.stickerList = watermarkViewModel.stickers.map { .init(image: $0) }
        }
        .fullScreenCover(isPresented: $viewModel.isShowPicker) {
//            guard let type = viewModel.pickerType else { return }
            viewModel.loadImages()
//            viewModel.autoSetting()
//            viewModel.makePreview()
        } content: {
            if let type = viewModel.pickerType {
                switch type {
                case .watermark:
                    AssetPickerView(avAsset: $watermarkViewModel.originImages,
                                    type: type.mediaType,
                                    limit: type.maxCount)
                case .sticker:
                    AssetPickerView(avAsset: $watermarkViewModel.originSticker,
                                    type: type.mediaType,
                                    limit: type.maxCount)
                }
            }
        }
    }
}
