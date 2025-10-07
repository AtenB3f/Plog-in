//
//  PickAssetView.swift
//  Plogin
//
//  Created by AtenB on 6/6/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Photos
import PhotosUI
import AVKit

struct PickAssetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AssetViewModel
    
    @State var index: Int = 0
    @State private var showPicker = false
    @State var mediaType: MediaType = .all
    
    var body: some View {
        VStack {
            ShowMediaView(index: $index)
                .environmentObject(viewModel)
            
            Button("둘 다 선택") {
                showPicker = true
                mediaType = .all
            }

            Button("영상 선택") {
                showPicker = true
                mediaType = .video
            }
            
            Button("사진 선택") {
                showPicker = true
                mediaType = .image
            }
            
            Button("다음") {
                viewModel.pushNavigation(.editImage)
            }
        }
        .padding()
        .sheet(isPresented: $showPicker) {
            AssetPickerView(avAsset: $viewModel.assets, type: mediaType)
        }
    }
}
