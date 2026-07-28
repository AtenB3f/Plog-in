//
//  WatermarkResultView.swift
//  Plogin
//
//  Created by AtenB on 1/6/26.
//  Copyright © 2026 AtenB. All rights reserved.
//

import SwiftUI
import Design
import PlatformCore

public struct WatermarkResultView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: WatermarkResultViewModel

    public init(
        viewModel: WatermarkResultViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationTitle(
                title: "미리보기",
                leftIcon: .iconChevronLeftSM,
                rightIcon: .iconSave, callback: { isRight in
                if isRight {
                    viewModel.action(.save)
                } else {
                    dismiss()
                }
            })
            
            TabView(selection: $viewModel.indexPreview) {
                ForEach(viewModel.preview, id: \.self) { image in
                    Image(pImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(.page)
        }
        .frame(maxHeight: .infinity)
        .background(Color.black)
        .overlay {
            if viewModel.viewState == .loading {
                SkeletonView()
            }
        }
        .task {
            viewModel.action(.appear)
        }
    }
}
