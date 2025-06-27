//
//  PhotoSelectView.swift
//  Plogin
//
//  Created by AtenB on 5/11/25.
//  Copyright © 2025 Plli. All rights reserved.
//
import AVKit
import SwiftUI

enum EditStep: Hashable, Codable {
    case pickAsset
    case cropRatio
    case filter
}

struct ContentView: View {
    
    @StateObject var viewModel = AssetViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.viewPath) {
            VStack {
                Button {
                    viewModel.pushNavigation(.pickAsset)
                } label: {
                    Text("미디어 선택")
                }
            }
            .navigationDestination(for: EditStep.self) { step in
                stepView(step)
            }
        }
    }
    
    @ViewBuilder
    func stepView(_ step: EditStep) -> some View {
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
        }
    }
}
