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
                cell()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func page() -> some View {
        TabView(selection: $viewModel.page) {
            ForEach(viewModel.origins.indices, id: \.self) { index in
                let image = viewModel.origins[index]
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
                    .tag(index)
            }
        }
        .tabViewStyle(.page)
    }
    
    @ViewBuilder
    func cell() -> some View {
        WatermarkCell(
            rows: viewModel.store.watermark.array.rows,
            columns: viewModel.store.watermark.array.columns,
            images: viewModel.origins,
            ratio: viewModel.format.getCellRatio(images: viewModel.origins)
        )
        .overlay {
            if viewModel.store.watermark.text.isGradient {
                LinearGradient(gradient: .plave, startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            WatermarkText(imageSize: viewModel.format.getCell(images: viewModel.origins, array: viewModel.store.watermark.array))
                .environmentObject(viewModel)
        }
        .drawingGroup()
    }
}

struct WatermarkCell: View {
    let rows: Int
    let columns: Int
    let images: [PImage]
    let ratio: CGFloat
    
    init(
        rows: Int,
        columns: Int,
        images: [PImage],
        ratio: CGFloat
    ) {
        self.rows = rows
        self.columns = columns
        self.images = images
        self.ratio = ratio
    }

    var body: some View {
        Grid {
            ForEach(0..<columns, id: \.self) { column in
                GridRow(alignment: .center) {
                    ForEach(0..<rows, id: \.self) { row in
                        let index = (rows * column + row)
                        if index < images.count {
                            Image(uiImage: images[index])
                                .resizable()
                                .aspectRatio(ratio, contentMode: .fit)
                        } else {
                            Color.clear
                                .aspectRatio(ratio, contentMode: .fit)
                        }
                    }
                }
            }
        }
    }
}
