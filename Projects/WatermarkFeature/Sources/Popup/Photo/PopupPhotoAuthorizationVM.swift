//
//  PopupPhotoAuthorizationVM.swift
//  WatermarkFeature
//
//  Created by AtenB on 10/23/26.
//

import SwiftUI
import Photos
import UISchema
import PlatformExport

public class PopupPhotoAuthorizationVM: PopupViewModel {
    public enum PopupType {
        /// 사진 접근 거부/제한
        case denied
        /// 선택한 사진만 허용된 상태에서 허용되지 않은 사진 선택
        case limited
    }

    public enum Action {
        case cancel
        case confirm
    }

    let type: PopupType
    private let coodinator: WatermarkPopupCoordinator

    public init(
        type: PopupType,
        coodinator: WatermarkPopupCoordinator
    ) {
        self.type = type
        self.coodinator = coodinator
    }
}

@MainActor
public extension PopupPhotoAuthorizationVM {
    func action(_ action: Action) {
        switch action {
        case .cancel:
            cancel()
        case .confirm:
            confirm()
        }
    }
}

@MainActor
private extension PopupPhotoAuthorizationVM {
    // 미리보기 팝업 흐름에서는 미리보기를 먼저 닫은 뒤 표시되어 dismiss step을 처리할 곳이 없으므로 직접 pop
    func cancel() {
        coodinator.pop()
    }

    func confirm() {
        #if os(iOS)
        switch type {
        case .denied:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        case .limited:
            AssetPicker.pushAddAsset()
        }
        #endif
        coodinator.pop()
    }
}

extension PHAuthorizationStatus {
    /// picker를 표시할 수 없는 권한 상태인 경우 표시할 팝업
    var deniedRoute: WatermarkPopupRoute? {
        switch self {
        case .authorized, .limited:
            return nil
        case .denied, .restricted:
            // 시스템 권한 요청 팝업에서 방금 거부한 경우 포함
            return .photoDenied
        case .notDetermined:
            // authorize()에서 시스템 권한 요청 팝업을 띄운 뒤 결과를 반환하므로 정상 흐름에서는 도달하지 않음
            return .photoDenied
        @unknown default:
            return .photoDenied
        }
    }
}
