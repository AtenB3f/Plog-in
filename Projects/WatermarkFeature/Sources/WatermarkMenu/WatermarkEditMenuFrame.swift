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

struct WatermarkFrameItemModel {
    let id = UUID()
    var image: PImage
    var title: String?
    
    init(image: PImage, title: String = "") {
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
                FrameList(
                    list: viewModel.frames.map { PImage(data: $0.frame.thumbnailData ?? Data()) ?? PImage() },
                    state: $viewModel.frameState,
                    onDelete: { viewModel.action(.removeAt(.frame, $0)) },
                    onMove: { viewModel.action(.move(.frame, $0, $1)) }
                )
                .padding(.vertical, 6)
                .background(Color.Base.medium)
                .foldingHeight(!viewModel.frames.isEmpty)
            }
            
            Button {
                viewModel.action(.update(.frame(.save)))
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
            .foldingHeight(viewModel.currentFrameUUID != viewModel.store.watermark.id)
            
            CategoryButton(
                title: "프레임 제목",
                button: viewModel.store.watermark.frame.title,
                onClick: {
                    viewModel.action(.update(.frame(.title)))
            })
            .foldingHeight(viewModel.currentFrameUUID != nil)
        }
        .padding(.vertical, 12)
    }
}
