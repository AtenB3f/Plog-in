//
//  WatermarkEditMenuArray.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct WatermarkArrayItemModel: TitleImagable {
    let id = UUID()
    var image: PImage?
    var title: String?
    var size: CGFloat = 76
}

struct WatermarkEditMenuArray: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    @EnvironmentObject var watermarkViewModel: WatermarkViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                CategoryContentItemView(title: "배치") {
                    Button {
                        viewModel.isShowArrayType.toggle()
                    } label: {
                        HStack(spacing: 0) {
                            Text(viewModel.arrayType.menuName)
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
                            watermarkViewModel.setArray(type: type)
                            viewModel.setArray(watermark: watermarkViewModel.watermark, type: type)
                        } label: {
                            Text(type.menuName)
                                .font(watermarkViewModel.watermark.arraySetting.type == type ? .bold2 : .body2)
                                .foreground(watermarkViewModel.watermark.arraySetting.type == type ?  .Text.light : .Gray.medium)
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
                    rows: $watermarkViewModel.watermark.arraySetting.rows,
                    columns: $watermarkViewModel.watermark.arraySetting.columns)
                .frame(width: viewModel.isShowGrid ? nil : 0)
                .padding(.vertical, 12)
                .foldingHeight(viewModel.isShowGrid)
                .onChange(of: watermarkViewModel.watermark.arraySetting) {
                    watermarkViewModel.setArray()
                    viewModel.setArray(
                        watermark: watermarkViewModel.watermark,
                        rows: watermarkViewModel.watermark.arraySetting.rows,
                        columns: watermarkViewModel.watermark.arraySetting.columns)
                }
            }
            
            if viewModel.images.count > 1 {
                VStack(spacing: 0) {
                    CategoryTitleItemView("순서 변경")
                    
                    FrameList(mode: .constant(.sort),
                              list: $viewModel.arrayItems,
                              select: .constant(nil))
                }
            }
        }
        .padding(.vertical, 12)
    }
}



//#Preview {
//    let viewModel = WatermarkEditViewModel()
//    
//    WatermarkEditMenuArray()
//        .environmentObject(viewModel)
//        .background {
//            Color.black
//        }
//}

