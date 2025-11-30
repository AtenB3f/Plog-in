//
//  ImageEditView.swift
//  Plogin
//
//  Created by AtenB on 6/6/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI

struct ImageEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = WatermarkEditViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.watermark.textSetting.color.opacity)")
                .foreground(.red)
                
            Slider(value: $viewModel.watermark.textSetting.color.opacity, onEditingChanged: { _ in
                viewModel.makePreview()
            })
            TabView(selection: $viewModel.page) {
                ForEach(viewModel.previews, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(.page)
        }
        .task {
            viewModel.watermark.textSetting.text = "test"
            viewModel.watermark.textSetting.color = .init(.white)
            viewModel.isShowPicker = true
        }
        .fullScreenCover(isPresented: $viewModel.isShowPicker, onDismiss: {
            viewModel.loadImages()
            viewModel.autoSetting()
            viewModel.makePreview()
        }) {
            AssetPickerView(avAsset: $viewModel.assets, type: .image, limit: 30)
        }
    }
}
