//
//  AssetPicker.swift
//  PlatformExport
//
//  Created by AtenB on 5/15/26.
//

import Foundation
import AVFoundation
import Combine
import Photos
#if os(iOS)
import UIKit
#endif
import PlatformCore
import CoreDomain

public class AssetPicker: ObservableObject {
    @Published public var videos: [AVAsset] = []
    @Published public var images: [PImage] = []
    var mediaType: MediaType
    var limit: Int
    let crashReport: CrashReport?

    // AssetPicker에서 발생 이벤트. 메인 스레드에서 전달 필요
    let eventSubject = PassthroughSubject<AssetPickerEvent, Never>()
    public var event: AnyPublisher<AssetPickerEvent, Never> { eventSubject.eraseToAnyPublisher() }

    public init(
        mediaType: MediaType,
        limit: Int,
        crashReport: CrashReport? = nil
    ) {
        self.mediaType = mediaType
        self.limit = limit
        self.crashReport = crashReport
    }
    
    public init(
        type: PickerType,
        crashReport: CrashReport? = nil
    ) {
        self.mediaType = type.mediaType
        self.limit = type.maxCount
        self.crashReport = crashReport
    }
}

public extension AssetPicker {
    /// 사진 접근 권한 확인
    /// - Returns: 권한 상태
    @MainActor
    func authorize() async -> PHAuthorizationStatus {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        guard status == .notDetermined else { return status }
        return await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
}

#if os(iOS)
public extension AssetPicker {
    /// 선택한 사진만 허용된 권한 상태 시  접근 허용 사진을 추가 시스템 팝업
    @MainActor
    static func pushAddAsset(completion: (() -> Void)? = nil) {
        guard let controller = topViewController() else {
            completion?()
            return
        }
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: controller) { _ in
            DispatchQueue.main.async { completion?() }
        }
    }

    @MainActor
    private static func topViewController() -> UIViewController? {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
        var controller = window?.rootViewController
        while let presented = controller?.presentedViewController {
            controller = presented
        }
        return controller
    }
}
#endif

public enum AssetPickerEvent {
    case error(_ error: AssetPickerError)
    /// picker 종료 및 선택한 에셋 로드 처리 완료 (취소, 성공/실패 무관)
    case finished
}

public enum PickerType {
    case watermark
    case sticker
}

public extension PickerType {
    var maxCount: Int {
        switch self {
        case .watermark:
            return 36
        case .sticker:
            return 10
        }
    }
    
    var mediaType: MediaType {
        switch self {
        case .watermark:
            return .image
        case .sticker:
            return .image
        }
    }
}

public enum AssetPickerError: Error {
    case missingAssetIdentifier
    case assetNotFound
    case videoLoadFailed
    case imageLoadFailed
    case limitedAccess
}
