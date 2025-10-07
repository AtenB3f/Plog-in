//
//  WatermarkEditView.swift
//  Plogin
//
//  Created by AtenB on 8/9/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI

struct WatermarkEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var assetViewModel: AssetViewModel
    @StateObject var viewModel = WatermarkEditVIewModel()
    let editer = ImageEditManager()
    
    @State var index: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                TabView(selection: $viewModel.index) {
                    ForEach(Array(viewModel.generatedImage.enumerated()), id: \.offset) { index, image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                    }
                }
                .tabViewStyle(.page)
                
                TextField("텍스트를 입력하세요.", text: $viewModel.inputText)
                    .onSubmit {
                        viewModel.generatedImageAll(assetViewModel.filterImage())
                    }
                    .padding()
            }
        }
        .onChange(of: viewModel.inputText) { _ in
//            viewModel.generatedImageAll(assetViewModel.filterImage())
            let origin = assetViewModel.filterImage()[index]
            viewModel.generatedImage(origin, index: index) 
        }
        .task {
            viewModel.generatedImage = assetViewModel.filterImage()
            viewModel.generatedImageAll(assetViewModel.filterImage())
        }
    }
}
