//
//  WatermarkEditMenuSticker.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct WatermarkStickerItemModel: TitleImagable {
    let id = UUID()
    var image: PImage?
    var title: String?
    var size: CGFloat = 76
    
    init(image: PImage?) {
        self.image = image
    }
}

struct WatermarkEditMenuSticker: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    @EnvironmentObject var watermarkViewModel: WatermarkViewModel
    var body: some View {
        VStack {
            CategoryContentItemView(title: "스티커") {
                HStack {
                    if let index = watermarkViewModel.selectSticker,
                        viewModel.stickerListMode == .select {
                        Button {
                            guard watermarkViewModel.originSticker.count < PickerType.sticker.maxCount else { return }
                            let asset = watermarkViewModel.originSticker[index]
                            watermarkViewModel.originSticker.append(asset)
                            watermarkViewModel.selectSticker = nil
                        } label: {
                            Text("복제하기")
                                .font(.bold2)
                                .foreground(.Text.light)
                        }
                    }
                    
                    Button {
                        viewModel.pushPicker(.sticker)
                    } label: {
                        IconLabel(text: "불러오기", icon: .iconChevronRightSM)
                    }
                }
            }
            
            VStack(spacing: 0) {
                CategoryContentItemView(title: "편집", content: {
                    HStack {
                        if viewModel.stickerListMode == .edit {
                            Button {
                                watermarkViewModel.originSticker.removeAll()
                                viewModel.stickerListMode = .none
                            } label: {
                                Text("모두 삭제")
                                    .font(.bold2)
                                    .foreground(.Text.light)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 6)
                            }
                        }
                        
                        Button {
                            if viewModel.stickerListMode == .edit {
                                viewModel.stickerListMode = .none
                            } else {
                                viewModel.stickerListMode = .edit
                            }
                        } label: {
                            Text(viewModel.stickerListMode == .edit ? "편집 종료" : "편집모드")
                                .font(.bold2)
                                .foreground(.Text.light)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                        }
                    }
                })
                FrameList(mode: $viewModel.stickerListMode,
                          list: $viewModel.stickerList,
                          select: $watermarkViewModel.selectSticker)
                .foldingHeight(!watermarkViewModel.stickers.isEmpty)
            }
            .foldingHeight(!watermarkViewModel.originSticker.isEmpty)
        }
        .padding(.vertical, 12)
        .onTapGesture {
            if viewModel.stickerListMode != .edit {
                viewModel.stickerListMode = .none
            }
        }
    }
}
