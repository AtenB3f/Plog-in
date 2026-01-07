//
//  WatermarkView.swift
//  Plogin
//
//  Created by AtenB on 12/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct WatermarkView: View {
    @EnvironmentObject var viewModel: WatermarkViewModel
    
    @State var page: Int = 0
    
    var body: some View {
        Group {
            if viewModel.watermark.arraySetting.type == .none {
                TabView(selection: $page) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay {
                                if viewModel.watermark.textSetting.isGradient {
                                    LinearGradient(gradient: .plave, startPoint: .topLeading, endPoint: .bottomTrailing)
                                }
                                GeometryReader { proxy in
                                    let aspectedSize = viewModel.images.first?.size ?? .zero
                                    WatermarkText(proxy: proxy, aspectedSize: aspectedSize)
                                        .environmentObject(viewModel)
                                    
                                    WatermarkSticker(proxy: proxy, aspectedSize: aspectedSize)
                                        .environmentObject(viewModel)
                                }
                            }
                    }
                }
                .tabViewStyle(.page)
            } else {
                WatermarkCellView(
                    rows: $viewModel.watermark.arraySetting.rows,
                    columns: $viewModel.watermark.arraySetting.columns,
                    images: $viewModel.images,
                    ratio: viewModel.editor.getCellSize(images: viewModel.images).ratio
                )
                .overlay {
                    if viewModel.watermark.textSetting.isGradient {
                        LinearGradient(gradient: .plave, startPoint: .topLeading, endPoint: .bottomTrailing)
                    }
                    GeometryReader { proxy in
                        let aspectedSize = viewModel.editor.getCellSize(images: viewModel.images)
                        WatermarkText(proxy: proxy, aspectedSize: aspectedSize)
                            .environmentObject(viewModel)
                        
                        WatermarkSticker(proxy: proxy, aspectedSize: aspectedSize)
                            .environmentObject(viewModel)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WatermarkCellView: View {
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

struct WatermarkText: View {
    @EnvironmentObject var viewModel: WatermarkViewModel
    
    @State var proxy: GeometryProxy
    @State var aspectedSize: CGSize
    
    @State var fontSize: CGFloat = .zero
    @State var measuredCellSize: CGSize = .zero
//    @State var editMode: Bool = false
    
    @State private var dragStartScale: CGFloat = 1.0
    @State private var dragStartPoint: CGPoint = .zero
    private let minScale: CGFloat = 0.3
    private let maxScale: CGFloat = 4.0
    
    @GestureState private var magnifyBy = 1.0
    
    init(proxy: GeometryProxy, aspectedSize: CGSize) {
        self.proxy = proxy
        self.aspectedSize = aspectedSize
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            let center = CGPoint(x: proxy.size.width/2, y: proxy.size.height/2)
            ZStack(alignment: .center) {
                Group {
                    WatermarkTextCell(
                        textSetting: viewModel.watermark.textSetting,
                        scale: proxy.size.width/aspectedSize.width*viewModel.watermark.textSetting.scale,
                        fontSize: viewModel.watermark.textSetting.getFontSize(proxy.size.width)*viewModel.watermark.textSetting.scale
                    )
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
                        }
                    )
                }
                .id(viewModel.watermark.textSetting.scale)
                
                repeatText(center: center)
            }
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                if newSize != .zero { measuredCellSize = newSize }
                if viewModel.watermark.textSetting.scale < minScale { viewModel.watermark.textSetting.scale = minScale }
                if viewModel.watermark.textSetting.scale > maxScale { viewModel.watermark.textSetting.scale = maxScale }
            }
            .clipped()
            .highPriorityGesture(
                MagnifyGesture()
                    .updating($magnifyBy) { value, gestureState, transaction in
                        if viewModel.textEditMode {
                            gestureState = value.magnification
                            viewModel.watermark.textSetting.scale = value.magnification
                        }
                    }
            )
            .simultaneousGesture(
                RotationGesture()
                    .onChanged { angle in
                        if viewModel.textEditMode {
                            viewModel.watermark.textSetting.rotation = angle.degrees
                        }
                    }
            )
            .onTapGesture {
                viewModel.textEditMode = true
            }
            
            if viewModel.textEditMode {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .stroke(lineWidth: 2)
                        .foreground(.white)
                        .shadow(.light)
                        .frame(width: measuredCellSize.width, height: measuredCellSize.height)
                        .rotationEffect(.degrees(viewModel.watermark.textSetting.rotation))
//                        .offset(y: -14)
                    
                    Button {
                        viewModel.textEditMode = false
                    } label: {
                        Image.iconCloseSM
                            .resizable()
                            .foreground(.Base.light)
                            .background(Circle())
                            .frame(width: 28, height: 28)
                    }
                }
                .frame(height: measuredCellSize.height)
            }
        }
    }
    
    @ViewBuilder
    func repeatText(center: CGPoint) -> some View {
        if measuredCellSize != .zero {
            let maxXRepeats = Int(ceil(proxy.size.width / measuredCellSize.width / 2) + 1)
            let maxYRepeats = Int(ceil(proxy.size.height / measuredCellSize.height / 2) + 1)
            
            ForEach(0...maxXRepeats, id: \.self) { row in
                ForEach(0...maxYRepeats, id: \.self) { col in
                    if col != 0 || row != 0 {
                        let dx = (CGFloat(row) * measuredCellSize.width)
                        let dy = (CGFloat(col) * measuredCellSize.height)
                        
                        if row != 0 {
                            WatermarkTextCell(
                                textSetting: viewModel.watermark.textSetting,
                                scale: proxy.size.width/aspectedSize.width*viewModel.watermark.textSetting.scale,
                                fontSize: viewModel.watermark.textSetting.getFontSize(proxy.size.width)*viewModel.watermark.textSetting.scale
                            )
                            .position(x: center.x + dx, y: center.y + -dy)
                            
                            WatermarkTextCell(
                                textSetting: viewModel.watermark.textSetting,
                                scale: proxy.size.width/aspectedSize.width*viewModel.watermark.textSetting.scale,
                                fontSize: viewModel.watermark.textSetting.getFontSize(proxy.size.width)*viewModel.watermark.textSetting.scale
                            )
                            .position(x: center.x + -dx, y: center.y + dy)
                        }
                        if col != 0 {
                            WatermarkTextCell(
                                textSetting: viewModel.watermark.textSetting,
                                scale: proxy.size.width/aspectedSize.width*viewModel.watermark.textSetting.scale,
                                fontSize: viewModel.watermark.textSetting.getFontSize(proxy.size.width)*viewModel.watermark.textSetting.scale
                            )
                            .position(x: center.x + dx, y: center.y + dy)
                            
                            WatermarkTextCell(
                                textSetting: viewModel.watermark.textSetting,
                                scale: proxy.size.width/aspectedSize.width*viewModel.watermark.textSetting.scale,
                                fontSize: viewModel.watermark.textSetting.getFontSize(proxy.size.width)*viewModel.watermark.textSetting.scale
                            )
                            .position(x: center.x + -dx, y: center.y + -dy)
                        }
                    }
                }
            }
        }
    }
}

struct WatermarkTextCell: View {
    let textSetting: WatermarkTextModel
    let scale: CGFloat
    let fontSize: CGFloat
    
    var body: some View {
        Text(textSetting.text + (textSetting.isDate ? "\n\(Date.now())" : ""))
            .multilineTextAlignment(.leading)
            .font(.custom(textSetting.fontName, size: fontSize))
            .foreground(textSetting.color.toUI)
            .rotationEffect(.degrees(textSetting.rotation))
            .padding(.horizontal, textSetting.spacingWidth * scale / 2)
            .padding(.vertical, textSetting.spacingWidth * scale / 2)
    }
}

struct WatermarkSticker: View {
    @EnvironmentObject var viewModel: WatermarkViewModel
    
    @State var proxy: GeometryProxy
    @State var aspectedSize: CGSize
    
    @GestureState private var magnifyBy = 1.0
    @GestureState private var posision: CGPoint = .zero
    
    var body: some View {
        ZStack {
            ForEach(viewModel.stickers.indices, id: \.self) { index in
                let drag = DragGesture()
                    .onChanged { value in
                        if viewModel.selectSticker == index {
                            viewModel.watermark.stickers[index].position.x = value.startLocation.x + value.translation.width - proxy.size.width/2
                            viewModel.watermark.stickers[index].position.y = value.startLocation.y + value.translation.height - proxy.size.height/2
                        }
                    }
                
                let magnify = MagnifyGesture()
                    .updating($magnifyBy) { value, gestureState, _ in
                        if viewModel.selectSticker == index {
                            gestureState = value.magnification
                            viewModel.watermark.stickers[index].scale = value.magnification
                        }
                    }
                
                let rotate = RotationGesture()
                    .onChanged { angle in
                        if viewModel.selectSticker == index {
                            viewModel.watermark.stickers[index].rotation = angle.degrees
                        }
                    }
                
                let combinedGesture = drag.simultaneously(with: magnify).simultaneously(with: rotate)
                
                Image(uiImage: viewModel.stickers[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(viewModel.watermark.stickers[index].scale)
                    .rotationEffect(.degrees(viewModel.watermark.stickers[index].rotation))
                    .offset(x: viewModel.watermark.stickers[index].position.x, y: viewModel.watermark.stickers[index].position.y)
                    .opacity(viewModel.watermark.stickers[index].alpha)
                    .overlay {
                        if viewModel.selectSticker == index {
                            Rectangle()
                                .stroke()
                                .foreground(.white)
                                .shadow(.light)
                                .scaleEffect(viewModel.watermark.stickers[index].scale)
                                .rotationEffect(.degrees(viewModel.watermark.stickers[index].rotation))
                                .offset(x: viewModel.watermark.stickers[index].position.x,
                                        y: viewModel.watermark.stickers[index].position.y)
                        }
                    }
                    .gesture(combinedGesture)
                    .id(index)
                    .onTapGesture {
                        viewModel.selectSticker = index
                    }
            }
        }
    }
}

//#Preview {
//    @State var isShow: Bool = false
//    let viewModel = WatermarkViewModel()
//    Button("toggle") {
//        withAnimation {
//            isShow = true
//        }
//    }
//    WatermarkView()
//        .environmentObject(viewModel)
//        .onAppear {
//            var image = PImage(named: "Melon_Streaming")!
//            viewModel.images.append(image)
//            viewModel.watermark.textSetting = .init(
//                text: "plave",
//                fontName: FontType.body1.fontName,
//                fontSize: FontType.body1.size,
//                rotation: -30,
//                color: .blue,
//                alpha: 1.0,
//                isDate: false
//            )
//            viewModel.watermark.arraySetting = .init(type: .grid, rows: 1, columns: 1)
//            viewModel.calculateSetting()
//        }
//    
//    if isShow {
//        Color.blue
//    }
//}

