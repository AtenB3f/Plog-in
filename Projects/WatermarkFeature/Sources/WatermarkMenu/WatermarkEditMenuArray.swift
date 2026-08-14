//
//  WatermarkEditMenuArray.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design
import PlatformCore
import WatermarkDomain

struct WatermarkEditMenuArray: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                CategoryContent(title: "배치") {
                    Button {
                        viewModel.action(.update(.array(.toggle)))
                    } label: {
                        HStack(spacing: 0) {
                            Text(viewModel.store.watermark.array.type.menuName)
                                .font(.bold1)
                                .foreground(.Text.light)
                            
                            (viewModel.isShowArrayType ? Image.iconChevronUpSM : Image.iconChevronDownSM)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foreground(.Text.light)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    Spacer()
                    ForEach(WatermarkArrayType.allCases, id: \.self) { type in
                        Button {
                            viewModel.action(.update(.array(.type(type))))
                        } label: {
                            Text(type.menuName)
                                .font(viewModel.store.watermark.array.type == type ? .bold2 : .body2)
                                .foreground(viewModel.store.watermark.array.type == type ?  .Text.light : .Gray.medium)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 6)
                                .background(Color.Base.medium)
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 4)
                .background(Color.Base.medium)
                .foldingHeight(viewModel.isShowArrayType)
                
                GridSelector(
                    rows: $viewModel.store.watermark.array.rows,
                    columns: $viewModel.store.watermark.array.columns)
                .frame(width: viewModel.store.watermark.array.type == .grid ? nil : 0)
                .padding(.vertical, 12)
                .foldingHeight(viewModel.isShowArrayType && viewModel.store.watermark.array.type == .grid)
            }
            
            if viewModel.picker.images.count >= 1 {
                VStack(spacing: 0) {
                    switch viewModel.arrayState.mode {
                    case .edit:
                        CategoryContent(title: "편집") {
                            HStack {
                                Button {
                                    viewModel.action(.remove(.array))
                                } label: {
                                    Text("모두 삭제")
                                        .font(.bold1)
                                        .foreground(.Text.light)
                                }
                                Button {
                                    viewModel.arrayState.mode = .none
                                } label: {
                                    Text("편집 종료")
                                        .font(.bold1)
                                        .foreground(.Text.light)
                                }
                            }
                        }
                    case .sort:
                        CategoryTitle("순서 변경")
                    default:
                        CategoryContent(title: "편집") {
                            Button {
                                viewModel.arrayState.mode = .edit
                            } label: {
                                Text("편집 모드")
                                    .font(.bold1)
                                    .foreground(.Text.light)
                            }
                        }
                    }
                    
                    FrameList(
                        list: viewModel.picker.images,
                        state: $viewModel.arrayState,
                        onDelete: { viewModel.action(.removeAt(.array, $0)) },
                        onMove: { viewModel.action(.move(.array, $0, $1)) }
                    )
                }
            } else {
                CategoryButton(
                    title: "이미지",
                    button: "불러오기",
                    onClick: {
                        viewModel.action(.open(.picture))
                    }
                )
            }
        }
        .padding(.vertical, 12)
    }
}
