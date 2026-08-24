//
//  WatermarkView.swift
//  Plogin
//
//  Created by AtenB on 12/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import PlatformCore
import WatermarkDomain

public struct WatermarkView: View {
    @StateObject var viewModel: WatermarkViewModel
    
    public init(
        viewModel: WatermarkViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        Group {
            if viewModel.store.watermark.array.type == .none {
                page()
            } else {
                cells()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            viewModel.action(.textMode)
        }
    }
    
    @ViewBuilder
    func page() -> some View {
        TabView(selection: $viewModel.page) {
            ForEach(viewModel.picker.images.indices, id: \.self) { index in
                let image = viewModel.picker.images[index]
                Image(pImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        gradientOverlay()
                    }
                    .drawingGroup()
                    .overlay {
                        WatermarkText(watermarkImageSize: image.size)
                            .environmentObject(viewModel)
                        WatermarkSticker(imageSize: image.size)
                            .environmentObject(viewModel)
                    }
                    .clipped()
                    .tag(index)
            }
        }
        .tabViewStyle(.page)
    }
    
    @ViewBuilder
    func cells() -> some View {
        let watermarkImageSize = viewModel.format.getWatermarkImageSize(
            origins: viewModel.picker.images,
            array: viewModel.store.watermark.array
        )

        WatermarkCells(viewModel: viewModel)
        .overlay {
            gradientOverlay()
        }
        .drawingGroup()
        .overlay {
            WatermarkText(watermarkImageSize: watermarkImageSize)
                .environmentObject(viewModel)
            WatermarkSticker(imageSize: watermarkImageSize)
                .environmentObject(viewModel)
        }
        .clipped()
    }

    @ViewBuilder
    func gradientOverlay() -> some View {
        if !viewModel.store.watermark.text.gradientColors.isEmpty {
            LinearGradient(
                gradient: Gradient(colors: viewModel.store.watermark.text.gradientColors.map { $0.toColor }),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct WatermarkCells: View {
    @StateObject var viewModel: WatermarkViewModel
    
    public init(
        viewModel: WatermarkViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<viewModel.store.watermark.array.rows, id: \.self) { row in
                GridRow(alignment: .center) {
                    ForEach(0..<viewModel.store.watermark.array.columns, id: \.self) { column in
                        let index = (viewModel.store.watermark.array.columns * row + column)
                        if index < viewModel.picker.images.count {
                            Color.clear
                                .aspectRatio(viewModel.format.getCellRatio(origins: viewModel.picker.images), contentMode: .fit)
                                .overlay(alignment: .center) {
                                    Image(uiImage: viewModel.picker.images[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .clipped()
//                                .aspectRatio(viewModel.format.getCellRatio(origins: viewModel.picker.images), contentMode: .fit)
                        } else {
                            Color.clear
                                .aspectRatio(viewModel.format.getCellRatio(origins: viewModel.picker.images), contentMode: .fit)
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    makePreviewWatermarkView()
}
#endif
