//
//  WatermarkEditMenuView.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

enum WatermarkEditMenuType: String, CaseIterable {
    case text
    case sticker
    case array
    case export
    case frame
    
    var menuName: String {
        switch self {
        case .text:
            return "텍스트"
        case .sticker:
            return "스티커"
        case .array:
            return "배열"
        case .export:
            return "출력"
        case .frame:
            return "프레임"
        }
    }
}

struct WatermarkEditMenuView: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    
                } label: {
                    
                }
                Button {
                    
                } label: {
                    
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.isShowMenu.toggle()
                    }
                } label: {
                    (viewModel.isShowMenu ? Image.iconMinus : Image.iconChevronUpSM)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            
            LineDivider(color: .Etc.divider)
            
            if viewModel.isShowMenu {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            WatermarkEditMenuText()
                                .containerRelativeFrame(.horizontal)
                                .environmentObject(viewModel)
                                .id(0)
                            
                            WatermarkEditMenuSticker()
                                .containerRelativeFrame(.horizontal)
                                .environmentObject(viewModel)
                                .id(1)

                            WatermarkEditMenuArray()
                                .containerRelativeFrame(.horizontal)
                                .environmentObject(viewModel)
                                .id(2)

                            WatermarkEditMenuExport()
                                .containerRelativeFrame(.horizontal)
                                .environmentObject(viewModel)
                                .id(3)

                            WatermarkEditMenuFrame()
                                .containerRelativeFrame(.horizontal)
                                .environmentObject(viewModel)
                                .id(4)
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .background(Color.Base.dark)
                    .onChange(of: viewModel.indexCategory) {
                        withAnimation {
                            proxy.scrollTo(viewModel.indexCategory)
                        }
                    }
                }
                .transition(.move(edge: .bottom))
            }
            
            CategoryTabbar(
                index: $viewModel.indexCategory,
                list: WatermarkEditMenuType.allCases.map { $0.menuName })
            .padding(.vertical)
            .padding(.horizontal, 20)
            .background(Color.black)
        }
        .background(Color.Base.dark)
    }
}
