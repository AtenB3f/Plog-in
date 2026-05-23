//
//  WatermarkSticker.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/21/26.
//

import SwiftUI

struct WatermarkSticker: View {
    @EnvironmentObject var viewModel: WatermarkViewModel
    
    @State var proxy: GeometryProxy
    @State var aspectedSize: CGSize
    
    @GestureState private var magnifyBy = 1.0
    @GestureState private var posision: CGPoint = .zero
    
    var body: some View {
        ZStack {
//            ForEach(viewModel.stickers.indices, id: \.self) { index in
//                let drag = DragGesture()
//                    .onChanged { value in
//                        if viewModel.selectSticker == index {
//                            viewModel.watermark.stickers[index].position.x = value.startLocation.x + value.translation.width - proxy.size.width/2
//                            viewModel.watermark.stickers[index].position.y = value.startLocation.y + value.translation.height - proxy.size.height/2
//                        }
//                    }
//
//                let magnify = MagnifyGesture()
//                    .updating($magnifyBy) { value, gestureState, _ in
//                        if viewModel.selectSticker == index {
//                            gestureState = value.magnification
//                            viewModel.watermark.stickers[index].scale = value.magnification
//                        }
//                    }
//
//                let rotate = RotationGesture()
//                    .onChanged { angle in
//                        if viewModel.selectSticker == index {
//                            viewModel.watermark.stickers[index].rotation = angle.degrees
//                        }
//                    }
//
//                let combinedGesture = drag.simultaneously(with: magnify).simultaneously(with: rotate)
//
//                Image(uiImage: viewModel.stickers[index])
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .scaleEffect(viewModel.watermark.stickers[index].scale)
//                    .rotationEffect(.degrees(viewModel.watermark.stickers[index].rotation))
//                    .offset(x: viewModel.watermark.stickers[index].position.x, y: viewModel.watermark.stickers[index].position.y)
//                    .opacity(viewModel.watermark.stickers[index].alpha)
//                    .overlay {
//                        if viewModel.selectSticker == index {
//                            Rectangle()
//                                .stroke()
//                                .foreground(.white)
//                                .shadow(.light)
//                                .scaleEffect(viewModel.watermark.stickers[index].scale)
//                                .rotationEffect(.degrees(viewModel.watermark.stickers[index].rotation))
//                                .offset(x: viewModel.watermark.stickers[index].position.x,
//                                        y: viewModel.watermark.stickers[index].position.y)
//                        }
//                    }
//                    .gesture(combinedGesture)
//                    .id(index)
//                    .onTapGesture {
//                        viewModel.selectSticker = index
//                    }
//            }
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

