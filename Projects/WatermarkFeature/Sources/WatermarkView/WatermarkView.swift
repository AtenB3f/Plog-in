//
//  WatermarkView.swift
//  Plogin
//
//  Created by AtenB on 12/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design
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
            viewModel.action(.textMode(isOn: false))
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
                        if viewModel.store.watermark.text.isGradient {
                            LinearGradient(gradient: .plave, startPoint: .topLeading, endPoint: .bottomTrailing)
                        }
                        WatermarkText(imageSize: image.size)
                            .environmentObject(viewModel)
                    }
                    .drawingGroup()
                    .overlay {
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
        WatermarkCells(viewModel: viewModel)
        .overlay {
            if viewModel.store.watermark.text.isGradient {
                LinearGradient(gradient: .plave, startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            WatermarkText(
                imageSize: viewModel.format.getCell(
                    images: viewModel.picker.images,
                    array: viewModel.store.watermark.array
                )
            )
                .environmentObject(viewModel)
        }
        .drawingGroup()
        .overlay {
            WatermarkSticker(imageSize: viewModel.format.getCell(images: viewModel.picker.images, array: viewModel.store.watermark.array))
                .environmentObject(viewModel)
        }
        .clipped()
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
                            Image(uiImage: viewModel.picker.images[index])
                                .resizable()
                                .aspectRatio(viewModel.format.getCellRatio(images: viewModel.picker.images), contentMode: .fit)
                        } else {
                            Color.clear
                                .aspectRatio(viewModel.format.getCellRatio(images: viewModel.picker.images), contentMode: .fit)
                        }
                    }
                }
            }
        }
    }
}
