//
//  WatermarkEditMenuView.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct WatermarkEditMenu: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                /*
                Button {
                    
                } label: {
                    
                }
                Button {
                    
                } label: {
                    
                }
                */
                Spacer()
                
                Button {
                    viewModel.action(.menu)
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
                content()
            }
            
            CategoryTabbar(
                index: $viewModel.indexCategory,
                list: WatermarkMenuType.allCases.map { $0.menuName }
            )
            .padding(.vertical)
            .padding(.horizontal, 20)
            .background(Color.black)
        }
        .background(Color.Base.dark)
    }
}

extension WatermarkEditMenu {
    @ViewBuilder
    func content() -> some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(Array(WatermarkMenuType.allCases.enumerated()), id: \.offset) { index, type in
                        if WatermarkMenuType.allCases[viewModel.indexCategory] == type {
                            menu(type)
                                .containerRelativeFrame(.horizontal)
                                .environmentObject(viewModel)
                                .tag(index)
                        }
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .background(Color.Base.dark)
            .onChange(of: viewModel.indexCategory) {
                let tag = WatermarkMenuType.allCases[viewModel.indexCategory]
                withAnimation {
                    proxy.scrollTo(tag.rawValue)
                }
            }
            .onAppear { proxy.scrollTo(viewModel.indexCategory) }
        }
        .transition(.move(edge: .bottom))
    }
    
    @ViewBuilder
    func menu(_ type: WatermarkMenuType) -> some View {
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
