//
//  FilterView.swift
//  Plogin
//
//  Created by AtenB on 6/6/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Design

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AssetViewModel
    @StateObject var filterViewModel = FilterViewModel()
    var multiple: Float = 3.0
    @State var index: Int = 0
    @State var image: Image?
    @State var uiImage: PImage?
    @State var originUIImage: PImage?
    var body: some View {
        ScrollView() {
            HStack {
//                ShowMediaView(index: $index)
//                    .environmentObject(viewModel)
                if let image = image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            
            Button("저장") {
                guard let uiImage = uiImage,
                      let image = filterViewModel.resizeImageByFactor(uiImage, scaleFactor: CGFloat(multiple)) else { return }
                
                filterViewModel.saveImage(image) { isSuccess , error in
                    
                }
            }
            
            VStack(spacing: 5) {
                Slider(value: $filterViewModel.filterData.noiseLevel,
                       in: FilterDataType.noiseLevel.range(multiple),
                       step: 0.005) {
                    Text("Noise Level: \(filterViewModel.filterData.noiseLevel, specifier: "%.3f")")
                        .foregroundStyle(.black)
                }

                Slider(value: $filterViewModel.filterData.noiseSharpness,
                       in: FilterDataType.noiseSharpness.range(multiple),
                       step: 0.05) {
                    Text("Noise Sharpness: \(filterViewModel.filterData.noiseSharpness, specifier: "%.2f")")
                        .foregroundStyle(.black)
                }

                Slider(value: $filterViewModel.filterData.sharpness,
                       in: FilterDataType.sharpness.range(multiple),
                       step: 0.1) {
                    Text("Sharpness: \(filterViewModel.filterData.sharpness, specifier: "%.2f")")
                        .foregroundStyle(.black)
                }

//                Slider(value: $filterViewModel.filterData.colorContrast, in: 0.5...1.5, step: 0.05) {
//                    Text("Color Contrast: \(filterViewModel.filterData.colorContrast, specifier: "%.2f")")
//                        .foregroundStyle(.black)
//                }
//
//                Slider(value: $filterViewModel.filterData.colorBrightness, in: -0.2...0.2, step: 0.01) {
//                    Text("Color Brightness: \(filterViewModel.filterData.colorBrightness, specifier: "%.2f")")
//                        .foregroundStyle(.black)
//                }
//
//                Slider(value: $filterViewModel.filterData.colorSaturation, in: 0.5...1.5, step: 0.05) {
//                    Text("Color Saturation: \(filterViewModel.filterData.colorSaturation, specifier: "%.2f")")
//                        .foregroundStyle(.black)
//                }
            }
            .padding()
        }
        .onChange(of: filterViewModel.filterData) { _ in
            if originUIImage == nil {
                guard index < viewModel.assets.count,
                      let asset = viewModel.assets[index].imageAsset else { return }
                uiImage = asset
                
#if os(iOS)
                self.image = Image(uiImage: asset)
#elseif os(macOS)
                self.image = Image(nsImage: asset)
#endif
            }
            
            uiImage = filterViewModel.upscaleImage(image: originUIImage!)
            guard let filterImage = uiImage else { return }
#if os(iOS)
            image = Image(uiImage: filterImage)
#elseif os(macOS)
            image = Image(nsImage: filterImage)
#endif
        }
        .onAppear {
            guard index < viewModel.assets.count,
                  let asset = viewModel.assets[index].imageAsset else { return }
            print(multiple)
            self.uiImage = filterViewModel.resizeImageByFactor(asset, scaleFactor: CGFloat(multiple))
            originUIImage = self.uiImage
            guard let origin = originUIImage else { return }
#if os(iOS)
            self.image = Image(uiImage: origin)
#elseif os(macOS)
            self.image = Image(nsImage: origin)
#endif
        }
    }
}
