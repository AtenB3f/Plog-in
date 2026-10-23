//
//  PopupPhotoAuthorization.swift
//  WatermarkFeature
//
//  Created by AtenB on 10/23/26.
//

import SwiftUI
import UISchema
import Design

public struct PopupPhotoAuthorization: View {
    @StateObject var viewModel: PopupPhotoAuthorizationVM

    public init(
        viewModel: PopupPhotoAuthorizationVM
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Popup(layout: viewModel)
            .task {
                viewModel.setHeader(type: .title, header: PopupHeaderTitle(title: "사진 접근 제한"))
                viewModel.setContent(type: .view, content: PopupContentView { makeContent() })
                viewModel.setButton(
                    type: .two,
                    button: PopupButtonTwo(
                        alignment: .horizonatal,
                        first: { makeLeftButton() },
                        second: { makeRightButton() }
                    )
                )
            }
    }
}

extension PopupPhotoAuthorization {
    @ViewBuilder
    func makeContent() -> some View {
        Text(description)
            .font(.body2)
            .foreground(.Gray.light)
            .multilineTextAlignment(.center)
            .padding(.vertical)
    }

    @ViewBuilder
    func makeLeftButton() -> some View {
        Button {
            viewModel.action(.cancel)
        } label: {
            GrayFillBoxLabel("취소")
        }
    }

    @ViewBuilder
    func makeRightButton() -> some View {
        Button {
            viewModel.action(.confirm)
        } label: {
            BlackFillBoxLabel(confirmTitle)
        }
    }

    var description: String {
        switch viewModel.type {
        case .denied:
            return "워터마크 편집을 위해\n사진 접근 권한이 필요합니다.\n설정에서 사진 접근을 허용해주세요."
        case .limited:
            return "선택한 사진에 접근할 수 있는 권한이 없습니다.\n접근을 허용할 사진을 추가해주세요."
        }
    }

    var confirmTitle: String {
        switch viewModel.type {
        case .denied:
            return "설정으로 이동"
        case .limited:
            return "사진 추가"
        }
    }
}
