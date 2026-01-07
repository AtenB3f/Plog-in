//
//  WatermarkEditMenuFrame.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct WatermarkFrameItemModel: TitleImagable {
    let id = UUID()
    var image: PImage?
    var title: String?
    var size: CGFloat = 76
    
    init(image: PImage?, title: String? = nil) {
        self.image = image
        self.title = title
    }
}

struct WatermarkEditMenuFrame: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    @EnvironmentObject var watermarkViewModel: WatermarkViewModel
    
    let manager = AppManager.shared
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                CategoryTitleItemView("설정 가져오기")
                FrameList(mode: $viewModel.frameListMode,
                          list: $viewModel.frameList,
                          select: $viewModel.frameSelect)
                .padding(.vertical, 6)
                .background(Color.Base.medium)
                .foldingHeight(!viewModel.frames.isEmpty)
            }
            
            Button {
//                viewModel.saveWatermarkFrame()
            } label: {
                HStack(spacing: 0) {
                    Image.iconSave
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foreground(.Text.light)
                    Text("현재 설정 저장하기")
                        .font(.bold2)
                        .foreground(.Text.light)
                }
            }
            .padding(16)
            .foldingHeight(!viewModel.frames.contains(where: { $0.id == watermarkViewModel.watermark.id }))
            
            CategoryButtonItemView(title: "제목",
                                   button: watermarkViewModel.watermark.frameSetting.title,
                                   onClick: {
                manager.pushPopup(.titleChange(
                    text: $viewModel.frameTitle,
                    callback: { title in
                        guard let title = title else { return }
                        watermarkViewModel.watermark.frameSetting.title = title
//                        viewModel.saveWatermarkFrame()
                }))
            })
            .foldingHeight(viewModel.frames.contains(where: { $0.id == watermarkViewModel.watermark.id }))
        }
        .padding(.vertical, 12)
    }
}
