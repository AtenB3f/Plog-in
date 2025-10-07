//
//  PhotoSelectView.swift
//  Plogin
//
//  Created by AtenB on 5/11/25.
//  Copyright © 2025 Plli. All rights reserved.
//
import AVKit
import SwiftUI

enum EditImageStep: Hashable, Codable {
    case pickAsset
    case cropRatio
    case filter
    case editImage
}

struct ContentView: View {
    
    @StateObject var viewModel = AssetViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.viewPath) {
            LoadYoutubeView()
            
            VStack {
                Button {
                    viewModel.pushNavigation(.pickAsset)
                } label: {
                    Text("미디어 선택")
                }
            }
            .navigationDestination(for: EditImageStep.self) { step in
                stepView(step)
            }
        }
    }
    
    @ViewBuilder
    func stepView(_ step: EditImageStep) -> some View {
        switch step {
        case .pickAsset:
            PickAssetView()
                .environmentObject(viewModel)
        case .cropRatio:
            CropRatioView()
                .environmentObject(viewModel)
        case .filter:
            FilterView()
                .environmentObject(viewModel)
        case .editImage:
            WatermarkEditView()
                .environmentObject(viewModel)
        }
    }
}
