//
//  WatermarkEditMenuExport.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct WatermarkEditMenuExport: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    @EnvironmentObject var watermarkViewModel: WatermarkViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                CategoryContentItemView(title: "출력 사이즈") {
                    Button {
                        viewModel.isShowExport.toggle()
                    } label: {
                        HStack(spacing: 0) {
                            if watermarkViewModel.watermark.exportSetting.type == .auto {
                                Text("auto")
                                    .font(.body1)
                                    .foreground(.Text.dark)
                                    .padding(.horizontal, 6)
                                
                            }
                            
                            Text(watermarkViewModel.watermark.exportSetting.getSizeStr())
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
                    ForEach(WatermarkExportType.allCases, id: \.self) { type in
                        Button {
                            viewModel.setExport(
                                watermark: watermarkViewModel.watermark,
                                type: type,
                                size: watermarkViewModel.watermark.exportSetting.getSize())
                        } label: {
                            Text(type.menuName)
                                .font(watermarkViewModel.watermark.exportSetting.type == type ? .bold2 : .body2)
                                .foreground(watermarkViewModel.watermark.exportSetting.type == type ?  .Text.light : .Gray.medium)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 6)
                                .background(Color.Base.medium)
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 4)
                .background(Color.Base.medium)
                .foldingHeight(viewModel.isShowExport)
            }
            
            CategoryContentItemView(title: "배율") {
                HStack(alignment: .center, spacing: 8) {
                    TextSlider(value: $watermarkViewModel.watermark.exportSetting.multiple, min: 0.1, max: 1.5)
                    Text("×" + String(format: "%.2f", watermarkViewModel.watermark.exportSetting.multiple))
                        .font(.body2)
                        .foreground(.Text.light)
                        .frame(width: 35)
                }
            }
            .foldingHeight(viewModel.isShowExportSlider)
        }
        .padding(.vertical, 12)
    }
}
