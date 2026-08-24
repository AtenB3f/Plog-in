//
//  WatermarkEditMenuText.swift
//  Plogin
//
//  Created by AtenB on 11/25/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import PlatformCore
import WatermarkDomain
import Design

struct WatermarkEditMenuText: View {
    @EnvironmentObject var viewModel: WatermarkEditViewModel
    
    var body: some View {
        VStack {
            text()
            color()
            opacity()
            spacing()
            options()
        }
        .padding(.vertical, 12)
    }
}

extension WatermarkEditMenuText {
    @ViewBuilder
    func text() -> some View {
        VStack(spacing: 0) {
            CategoryButton(
                title: "문구",
                button: "입력하기",
                onClick: {
                    viewModel.action(.popup(.word))
                }
            )
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(viewModel.words, id: \.self) { word in
                        Button {
                            viewModel.action(.update(.text(.word(word))))
                        } label: {
                            HStack(spacing: 0) {
                                Text(word)
                                    .font(viewModel.store.watermark.text.text == word ? .bold2 : .body2)
                                    .foreground(viewModel.store.watermark.text.text == word ? .Text.light : .Gray.medium)
                                if viewModel.store.watermark.text.text == word {
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
            .scrollIndicators(.hidden)
            .background(Color.Base.medium)
            .foldingHeight(!viewModel.words.isEmpty)
        }
    }
    
    @ViewBuilder
    func color() -> some View {
        CategoryContent(title: "색상") {
            HStack(spacing: 6) {
                ForEach(viewModel.colorPalet, id: \.self) { color in
                    Button {
                        viewModel.action(.update(.text(.color(color))))
                    } label: {
                        let colorData = ColorData(color, alpha: viewModel.store.watermark.text.color.opacity)
                        RoundedRectangle(cornerRadius: 2)
                            .foreground(color.opacity(viewModel.store.watermark.text.color == colorData ? 1.0 : 0.3))
                            .frame(width: viewModel.store.watermark.text.color == colorData ? 16: 12,
                                   height: viewModel.store.watermark.text.color == colorData ? 16: 12)
                            .padding(4)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func opacity() -> some View {
        CategoryContent(title: "불투명도") {
            HStack(alignment: .center, spacing: 8) {
                TextSlider(value: $viewModel.store.watermark.text.color.opacity, min: 0, max: 1, distance: 0.01)
                Text("\(Int(viewModel.store.watermark.text.color.opacity * 100))%")
                    .font(.body2)
                    .foreground(.Text.light)
                    .frame(width: 42, alignment: .leading)
            }
        }
    }
    
    @ViewBuilder
    func spacing() -> some View {
        CategoryContent(title: "간격") {
            HStack(alignment: .center, spacing: 8) {
                TextSlider(value: $viewModel.store.watermark.text.spacingWidthRatio, min: 0, max: 2, distance: 0.01)
                    .onChange(of: viewModel.store.watermark.text.spacingWidthRatio) {
                        viewModel.store.watermark.text.spacingHeightRatio = viewModel.store.watermark.text.spacingWidthRatio
                    }
                Text("\(Int(viewModel.store.watermark.text.spacingWidthRatio * 100))%")
                    .font(.body2)
                    .foreground(.Text.light)
                    .frame(width: 42, alignment: .leading)
            }
        }
    }
    
    @ViewBuilder
    func options() -> some View {
        CategoryContent(title: "옵션") {
            HStack(alignment: .center, spacing: 4) {
                Button {
                    viewModel.action(.update(.text(.date)))
                } label: {
                    IconLabel(
                        text: "날짜",
                        icon: .iconCheckSM,
                        color: viewModel.store.watermark.text.date != nil ? .Text.light : .Gray.dark,
                        size: 16)
                }
                Button {
                    viewModel.action(.update(.text(.gradient)))
                } label: {
                    IconLabel(
                        text: "그라데이션",
                        icon: .iconCheckSM,
                        color: viewModel.store.watermark.text.isGradient ? .Text.light : .Gray.dark,
                        size: 16
                    )
                }
            }
        }
    }
}
