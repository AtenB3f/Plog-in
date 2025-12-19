//
//  WatermarkEditMenuText.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design

struct WatermarkEditMenuText: View {
    let manager = AppManager.shared
    let dataManager = DataStore.shared
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    
    let colorPalet: [Color] = [.white, .Gray.medium, .black, .Yejun.main, .Noah.main, .Bamby.main, .Eunho.main, .Hamin.main]
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                CategoryButtonItemView(
                    title: "문구",
                    button: "입력하기",
                    onClick: {
                    manager.pushPopup(.watermarkTextSave(
                        text: $viewModel.newWord,
                        callback: { isSave in
                            if isSave { viewModel.saveWatermarkWord() }
                            manager.pushPopup()
                    }))
                })
                
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.words, id: \.self) { word in
                            Button {
                                viewModel.setText(text: word)
                            } label: {
                                HStack(spacing: 0) {
                                    Text(word)
                                        .font(viewModel.watermark.textSetting.text == word ? .bold2 : .body2)
                                        .foreground(viewModel.watermark.textSetting.text == word ? .Text.light : .Gray.medium)
                                    if viewModel.watermark.textSetting.text == word {
                                        Image.iconCheckSM
                                            .resizable()
                                            .renderingMode(.template)
                                            .foreground(.Text.light)
                                            .frame(width: 18, height: 18)
                                    }
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                            }   
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 4)
                }
                .background(Color.Base.medium)
                .foldingHeight(!viewModel.words.isEmpty)
            }
            
            CategoryContentItemView(title: "색상") {
                HStack(spacing: 6) {
                    ForEach(colorPalet, id: \.self) { color in
                        Button {
                            viewModel.setText(color: color, alpha: viewModel.watermark.textSetting.color.opacity)
                        } label: {
                            let colorData = ColorData(color, alpha: viewModel.watermark.textSetting.color.opacity)
                            RoundedRectangle(cornerRadius: 2)
                                .foreground(color.opacity(viewModel.watermark.textSetting.color == colorData ? 1.0 : 0.3))
                                .frame(width: viewModel.watermark.textSetting.color == colorData ? 16: 12,
                                       height: viewModel.watermark.textSetting.color == colorData ? 16: 12)
                                .padding(4)
                        }
                    }
                }
            }
            CategoryContentItemView(title: "불투명도") {
                HStack(alignment: .center, spacing: 8) {
                    TextSlider(value: $viewModel.watermark.textSetting.color.opacity, min: 0, max: 1, distance: 1)
                    Text(String(format: "%.0f", viewModel.watermark.textSetting.color.opacity * 100) + "%")
                        .font(.body2)
                        .foreground(.Text.light)
                        .frame(width: 35)
                }
            }
            CategoryContentItemView(title: "간격") {
                HStack(alignment: .center, spacing: 8) {
                    TextSlider(value: $viewModel.watermark.textSetting.spacingWidth, min: 0, max: 100, distance: 1)
                    Text(String(format: "%.1f", viewModel.watermark.textSetting.spacingWidth))
                        .font(.body2)
                        .foreground(.Text.light)
                        .frame(width: 35)
                }
            }
            CategoryContentItemView(title: "옵션") {
                HStack(alignment: .center, spacing: 4) {
                    Button {
                        let value = viewModel.watermark.textSetting.isDate
                        viewModel.setText(isDate: !value)
                    } label: {
                        IconLabel(text: "날짜",
                                  icon: .iconCheckSM,
                                  color: viewModel.watermark.textSetting.isDate ?  .Text.light : .Gray.dark,
                                  size: 16)
                    }
                    Button {
                        let value = viewModel.watermark.textSetting.isGradient
                        viewModel.setText(isGradient: !value)
                    } label: {
                        IconLabel(text: "그라데이션",
                                  icon: .iconCheckSM,
                                  color: viewModel.watermark.textSetting.isGradient ? .Text.light : .Gray.dark,
                                  size: 16)
                    }
                }
            }
        }
        .padding(.vertical, 12)
    }
}
