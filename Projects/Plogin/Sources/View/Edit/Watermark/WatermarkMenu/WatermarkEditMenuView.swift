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
                    
                } label: {
                    
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            
            LineDivider(color: .Etc.divider)
        }
        .background(Color.Base.dark)
        
        if viewModel.isShowMenu {
            TabView(selection: $viewModel.indexCategory) {
                WatermarkEditMenuText()
                    .id(0)
            }
        }
        
        CategoryTabbar(
            index: $viewModel.indexCategory,
            list: WatermarkEditMenuType.allCases.map { $0.rawValue })
            .background(Color.black)
    }
}
