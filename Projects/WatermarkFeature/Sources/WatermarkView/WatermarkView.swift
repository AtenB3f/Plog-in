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
            ForEach(viewModel.origins, id: \.self) { image in
                Image(pImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        if viewModel.store.watermark.text.isGradient {
                            LinearGradient(gradient: .plave, startPoint: .topLeading, endPoint: .bottomTrailing)
                        }
                        WatermarkText(image: image)
                            .environmentObject(viewModel)
                    }
                    .drawingGroup()
            }
        }
        .tabViewStyle(.page)
    }
    
    @ViewBuilder
    func cell() -> some View {
//        WatermarkCellView(
//            rows: $viewModel.store.watermark.array.rows,
//            columns: $viewModel.store.watermark.array.columns,
//            images: $viewModel.images,
//            ratio: 1//viewModel.editor.getCellSize(images: viewModel.images).ratio
//        )
    }
}

struct WatermarkCell: View {
    @Binding var rows: Int
    @Binding var columns: Int
    @Binding var images: [PImage]
    let ratio: CGFloat
    
    init(rows: Binding<Int>, columns: Binding<Int>, images: Binding<[PImage]>, ratio: CGFloat) {
        self._rows = rows
        self._columns = columns
        self._images = images
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
