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
            if viewModel.stickerState.mode != .edit {
                viewModel.stickerState.mode = .none
            }
        }
    }
}

extension WatermarkEditMenuSticker {
    @ViewBuilder
    func stickers() -> some View {
        CategoryContent(title: "스티커") {
            HStack {
                if viewModel.stickerState.index != nil,
                   viewModel.stickerState.mode == .select {
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
                    if viewModel.stickerState.mode == .edit {
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
                        if viewModel.stickerState.mode == .edit {
                            viewModel.stickerState.mode = .none
                        } else {
                            viewModel.stickerState.mode = .edit
                        }
                    } label: {
                        Text(viewModel.stickerState.mode == .edit ? "편집 종료" : "편집모드")
                            .font(.bold2)
                            .foreground(.Text.light)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 6)
                    }
                }
            })
            FrameList(
                list: viewModel.store.watermark.stickers.map { $0.image },
                state: $viewModel.stickerState,
                onDelete: { viewModel.action(.removeAt(.sticker, $0)) },
                onMove: { viewModel.action(.move(.sticker, $0, $1)) }
            )
            .foldingHeight(!viewModel.store.watermark.stickers.isEmpty)
        }
        .foldingHeight(!viewModel.store.watermark.stickers.isEmpty)
    }
}
