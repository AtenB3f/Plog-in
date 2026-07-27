//
//  HomeView.swift
//  Plogin
//
//  Created by AtenB on 10/7/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import SwiftUI
import Design
import WatermarkDomain

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    init(
        viewModel: HomeViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            LogoTitle()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HomeWatermarkView()
                        .environmentObject(viewModel)
                    
                    LineDivider(color: Color.Etc.divider)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    
                    HomeMenuTitle(title: "기본 프레임")
                    VStack(spacing: 2) {
                        ForEach(BasicWatermarkType.allCases, id: \.self) { type in
                            Button {
                                viewModel.clickBasicFrame(type)
                            } label: {
                                BasicWatermarkItemView(type: type)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    HomeMenuTitle(title: "커스텀 프레임")
                        .padding(.top, 20)
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(0..<9, id: \.self) { index in
                            Button {
                                viewModel.push(.watermarkEdit)
                            } label: {
                                CustomFrameItemView()
                            }
                            .fillBoxLabelButtonStyle()
                        }
                    }
                }
                .padding(.bottom, 50)
            }
            .background(Color.Base.dark)
            .sheet(isPresented: $viewModel.isShowPicker,
                   onDismiss: {
                
            }) {
//                AssetPickerView(avAsset: $viewModel.assets, type: viewModel.mediaType)
            }
        }
    }
}

//#Preview {
//    HomeView()
//}
