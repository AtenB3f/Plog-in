//
//  WatermarkEditMenuFrame.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design
import PlatformCore

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
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                CategoryTitle("설정 가져오기")
                FrameList(mode: $viewModel.frame.mode,
                          list: $viewModel.frame.list,
                          select: $viewModel.frame.select)
                .padding(.vertical, 6)
                .background(Color.Base.medium)
                .foldingHeight(!viewModel.frame.list.isEmpty)
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
            .foldingHeight(!viewModel.frame.list.contains(where: { $0.id == viewModel.store.watermark.id }))
            
            CategoryButton(
                title: "제목",
                button: viewModel.store.watermark.frame.title,
                onClick: {
//                manager.pushPopup(.titleChange(
//                    text: $viewModel.frameTitle,
//                    callback: { title in
//                        guard let title = title else { return }
//                        watermarkViewModel.watermark.frameSetting.title = title
////                        viewModel.saveWatermarkFrame()
//                }))
            })
            .foldingHeight(viewModel.frame.list.contains(where: { $0.id == viewModel.store.watermark.id }))
        }
        .padding(.vertical, 12)
    }
}
