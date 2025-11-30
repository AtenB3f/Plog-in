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
                } else {
                    dismiss()
                }
            })
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(Array(viewModel.previews), id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .padding(10)
            .task {
                viewModel.isShowPicker = true
            }
            
            WatermarkEditMenuView()
                .environmentObject(viewModel)
        }
        .background(Color.black)
        .fullScreenCover(isPresented: $viewModel.isShowPicker, onDismiss: {
            viewModel.loadImages()
            viewModel.autoSetting()
            viewModel.makePreview()
        }) {
            AssetPickerView(avAsset: $viewModel.assets, type: .image, limit: 30)
        }
    }
}
