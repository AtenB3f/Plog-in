//
//  WatermarkEditMenuExport.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design
import WatermarkDomain

struct WatermarkEditMenuExport: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                CategoryContent(title: "출력 사이즈") {
                    Button {
//                        viewModel.isShowExport.toggle()
                    } label: {
                        HStack(spacing: 0) {
                            if viewModel.store.watermark.export.type == .auto {
                                Text("auto")
                                    .font(.body1)
                                    .foreground(.Text.dark)
                                    .padding(.horizontal, 6)
                                
                            }
                            
                            Text(viewModel.store.watermark.export.getSizeStr())
                                .font(.bold1)
                                .foreground(.Text.light)
                            
//                            (viewModel.isShowArrayType ? Image.iconChevronUpSM : Image.iconChevronDownSM)
//                                .resizable()
//                                .renderingMode(.template)
//                                .frame(width: 24, height: 24)
//                                .foreground(.Text.light)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    Spacer()
                    ForEach(WatermarkExportType.allCases, id: \.self) { type in
                        Button {
//                            viewModel.setExport(
//                                watermark: viewModel.watermark,
//                                type: type,
//                                size: viewModel.watermark.export.getSize())
                        } label: {
                            Text(type.menuName)
                                .font(viewModel.store.watermark.export.type == type ? .bold2 : .body2)
                                .foreground(viewModel.store.watermark.export.type == type ?  .Text.light : .Gray.medium)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 6)
                                .background(Color.Base.medium)
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 4)
                .background(Color.Base.medium)
//                .foldingHeight(viewModel.isShowExport)
            }
            
            CategoryContent(title: "배율") {
                HStack(alignment: .center, spacing: 8) {
                    TextSlider(value: $viewModel.store.watermark.export.multiple, min: 0.1, max: 1.5)
                    Text("×" + String(format: "%.2f", viewModel.store.watermark.export.multiple))
                        .font(.body2)
                        .foreground(.Text.light)
                        .frame(width: 35)
                }
            }
//            .foldingHeight(viewModel.isShowExportSlider)
        }
        .padding(.vertical, 12)
    }
}
