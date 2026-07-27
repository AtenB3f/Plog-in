//
//  WatermarkEditView.swift
//  Plogin
//
//  Created by AtenB on 8/9/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Design
import PlatformExport

public struct WatermarkEditView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: WatermarkEditViewModel
    @StateObject var watermarkViewModel: WatermarkViewModel

    public init(
        viewModel: WatermarkEditViewModel,
        watermarkViewModel: WatermarkViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._watermarkViewModel = StateObject(wrappedValue: watermarkViewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationTitle(
                title: "워터마크 편집",
                leftIcon: .iconCloseMD,
                rightIcon: .iconSave, callback: { isRight in
                if isRight {
                    viewModel.action(.preview)
                } else {
                    dismiss()
                }
            })
            Button {
                viewModel.action(.open(.picture))
            } label: {
                Text("Picker")
            }
            WatermarkView(viewModel: watermarkViewModel)
                .padding(10)
            
            WatermarkEditMenu()
                .environmentObject(viewModel)
        }
        .frame(maxHeight: .infinity)
        .background(Color.black)
        .task {
            if viewModel.picker.images.isEmpty {
                viewModel.action(.open(.picture))
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowPicker) {
            viewModel.action(.picker)
        } content: {
            switch viewModel.pickerType {
            case .picture:
                AssetPickerView(picker: viewModel.picker)
            case .sticker:
                AssetPickerView(picker: viewModel.sticker)
            case .none:
                EmptyView()
            }
        }
    }
}

#if DEBUG
#Preview {
    makePreviewWatermarkEditView()
}
#endif
