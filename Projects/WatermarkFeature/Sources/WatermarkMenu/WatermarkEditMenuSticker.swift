//
//  WatermarkEditMenuSticker.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design
import PlatformCore

struct WatermarkEditMenuSticker: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    
    var body: some View {
        VStack {
            stickers()
            edit()
        }
        .padding(.vertical, 12)
        .onTapGesture {
            if viewModel.stickerMode != .edit {
                viewModel.stickerMode = .none
            }
        }
    }
}

extension WatermarkEditMenuSticker {
    @ViewBuilder
    func stickers() -> some View {
        CategoryContent(title: "스티커") {
            HStack {
                if let index = viewModel.stickerSelect,
                   viewModel.stickerMode == .select {
                    Button {
                        viewModel.action(.replicate(.sticker))
                    } label: {
                        Text("복제하기")
                            .font(.bold2)
                            .foreground(.Text.light)
                    }
                }
                
                Button {
                    viewModel.action(.open(.sticker))
                } label: {
                    IconLabel(text: "불러오기", icon: .iconChevronRightSM)
                }
            }
        }
    }
    
    @ViewBuilder
    func edit() -> some View {
        VStack(spacing: 0) {
            CategoryContent(title: "편집", content: {
                HStack {
                    if viewModel.stickerMode == .edit {
                        Button {
                            viewModel.action(.remove(.sticker))
                        } label: {
                            Text("모두 삭제")
                                .font(.bold2)
                                .foreground(.Text.light)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                        }
                    }
                    
                    Button {
                        if viewModel.stickerMode == .edit {
                            viewModel.stickerMode = .none
                        } else {
                            viewModel.stickerMode = .edit
                        }
                    } label: {
                        Text(viewModel.stickerMode == .edit ? "편집 종료" : "편집모드")
                            .font(.bold2)
                            .foreground(.Text.light)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 6)
                    }
                }
            })
            FrameList(
                mode: $viewModel.stickerMode,
                list: viewModel.sticker.images,
                select: $viewModel.stickerSelect
            )
            .foldingHeight(!viewModel.sticker.images.isEmpty)
        }
        .foldingHeight(!viewModel.sticker.images.isEmpty)
    }
}
