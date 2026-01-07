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
    @EnvironmentObject var watermarkViewModel: WatermarkEditViewModel
    
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
                            ForEach(WatermarkEditMenuType.allCases, id: \.self) { type in
                                if WatermarkEditMenuType.allCases[viewModel.indexCategory] == type {
                                    menuItems(type)
                                        .containerRelativeFrame(.horizontal)
                                        .environmentObject(viewModel)
                                        .environmentObject(watermarkViewModel)
                                        .id(type.rawValue)
                                } else {
                                    Spacer()
                                        .containerRelativeFrame(.horizontal)
                                        .frame(height: 1)
                                        .id(type.rawValue)
                                }
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .background(Color.Base.dark)
                    .onChange(of: viewModel.indexCategory) {
                        let tag = WatermarkEditMenuType.allCases[viewModel.indexCategory]
                        withAnimation {
                            proxy.scrollTo(tag.rawValue)
                        }
                    }
                    .onAppear { proxy.scrollTo(viewModel.indexCategory) }
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

extension WatermarkEditMenuView {
    @ViewBuilder
    func menuItems(_ type: WatermarkEditMenuType) -> some View {
        switch type {
        case .text:
            WatermarkEditMenuText()
        case .sticker:
            WatermarkEditMenuSticker()
        case .array:
            WatermarkEditMenuArray()
        case .export:
            WatermarkEditMenuExport()
        case .frame:
            WatermarkEditMenuFrame()
        }
    }
}
