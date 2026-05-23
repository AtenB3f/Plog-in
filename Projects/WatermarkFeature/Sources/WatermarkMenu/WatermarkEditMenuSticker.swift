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
            if viewModel.sticker.mode != .edit {
                viewModel.sticker.mode = .none
            }
        }
    }
}

extension WatermarkEditMenuSticker {
    @ViewBuilder
    func stickers() -> some View {
        CategoryContent(title: "스티커") {
            HStack {
                if let index = viewModel.sticker.select,
                   viewModel.sticker.mode == .select {
                    Button {
                        // TODO: 10 대신 enum
//                        guard viewModel.sticker.images.count < 10 else { return }
//                        let asset = viewModel.sticker.images[index]
//                        viewModel.sticker.images.append(asset)
//                        viewModel.sticker.select = nil
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
                    if viewModel.sticker.mode == .edit {
                        Button {
//                            viewModel.originSticker.removeAll()
//                            viewModel.stickerListMode = .none
                        } label: {
                            Text("모두 삭제")
                                .font(.bold2)
                                .foreground(.Text.light)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                        }
                    }
                    
                    Button {
//                        if viewModel.sticker.mode == .edit {
//                            viewModel.sticker.mode = .none
//                        } else {
//                            viewModel.sticker.mode = .edit
//                        }
                    } label: {
                        Text(viewModel.sticker.mode == .edit ? "편집 종료" : "편집모드")
                            .font(.bold2)
                            .foreground(.Text.light)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 6)
                    }
                }
            })
            FrameList(
                mode: $viewModel.sticker.mode,
                list: $viewModel.sticker.list,
                select: $viewModel.sticker.select
            )
//            .foldingHeight(!viewModel.stickers.isEmpty)
        }
        .foldingHeight(!viewModel.sticker.images.isEmpty)
    }
}
