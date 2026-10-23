//
//  AssetPickerView.swift
//  Plogin
//
//  Created by AtenB on 5/11/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import Photos
import PhotosUI
import AVFoundation
import PlatformCore

#if os(iOS)
public struct AssetPickerView: UIViewControllerRepresentable {
    @StateObject var picker: AssetPicker
    
    public init(
        picker: AssetPicker
    ) {
        self._picker = StateObject(wrappedValue: picker)
    }
}

extension AssetPickerView {
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = picker.limit
        if picker.mediaType != .all {
            config.filter = picker.mediaType == .video ? .videos : .images
        }
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    public class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: AssetPickerView
        
        init(_ parent: AssetPickerView) {
            self.parent = parent
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.isEmpty {
                picker.dismiss(animated: true)
                parent.picker.eventSubject.send(.finished)
                return
            }
            
            picker.dismiss(animated: true)

            var isLimitedAsset = false
            let group = DispatchGroup()
            
            for result in results {
                guard let assetId = result.assetIdentifier else {
                    self.parent.picker.crashReport?.send(
                        title: "AssetPickerView",
                        function: "picker",
                        key: "assetIdentifier",
                        value: "nil",
                        error: AssetPickerError.missingAssetIdentifier
                    )
                    parent.picker.eventSubject.send(.error(.missingAssetIdentifier))
                    continue
                }

                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                
                guard let phAsset = fetchResult.firstObject else {
                    // 권한 체크
                    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                    if status == .limited { isLimitedAsset = true }
                    
                    self.parent.picker.crashReport?.setValue("photoAuthorization", status.reportName)
                    self.parent.picker.crashReport?.send(
                        title: "AssetPickerView",
                        function: "picker",
                        key: "assetIdentifier",
                        value: assetId,
                        error: AssetPickerError.assetNotFound
                    )
                    
                    if status != .limited { parent.picker.eventSubject.send(.error(.assetNotFound)) }
                    
                    continue
                }
                switch phAsset.mediaType {
                case .video:
                    group.enter()
                    PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil) { avAsset, _, info in
                        guard let avAsset = avAsset,
                                let data = AssetData(type: .video, data: avAsset).videoAsset else {
                            let error = (info?[PHImageErrorKey] as? Error) ?? AssetPickerError.videoLoadFailed
                            self.parent.picker.crashReport?.send(
                                title: "AssetPickerView",
                                function: "requestAVAsset",
                                key: "assetIdentifier",
                                value: assetId,
                                error: error
                            )
                            DispatchQueue.main.async {
                                self.parent.picker.eventSubject.send(.error(.videoLoadFailed))
                                group.leave()
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            self.parent.picker.videos.append(data)
                            group.leave()
                        }
                    }
                case .image:
                    group.enter()
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .highQualityFormat
                    options.isSynchronous = false
                    PHImageManager.default().requestImage(
                        for: phAsset,
                        targetSize: CGSize(width: phAsset.pixelWidth, height: phAsset.pixelHeight),
                        contentMode: .aspectFit,
                        options: options) { image, info in
                            guard let image = image,
                                    let data = AssetData(type: .image, data: image).imageAsset else {
                                let error = (info?[PHImageErrorKey] as? Error) ?? AssetPickerError.imageLoadFailed
                                self.parent.picker.crashReport?.send(
                                    title: "AssetPickerView",
                                    function: "requestImage",
                                    key: "assetIdentifier",
                                    value: assetId,
                                    error: error
                                )
                                DispatchQueue.main.async {
                                    self.parent.picker.eventSubject.send(.error(.imageLoadFailed))
                                    group.leave()
                                }
                                return
                            }
                            self.parent.picker.images.append(data)
                            group.leave()
                    }
                default:
                    break
                }
            }

            if isLimitedAsset { parent.picker.eventSubject.send(.error(.limitedAccess)) }

            // picker가 닫히면 Coordinator가 먼저 해제될 수 있으므로, VM이 소유한 AssetPicker를 직접 캡처해서 전달
            let assetPicker = parent.picker
            group.notify(queue: .main) {
                assetPicker.eventSubject.send(.finished)
            }
        }
    }
}

private extension PHAuthorizationStatus {
    var reportName: String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorized: return "authorized"
        case .limited: return "limited"
        @unknown default: return "unknown(\(rawValue))"
        }
    }
}
#elseif os(macOS)
public struct AssetPickerView: View {
    @Binding var assetDatas: [AssetData]
    var mediaType: MediaType
    
    init(avAsset: Binding<[AssetData]>, type: MediaType) {
        self._assetDatas = avAsset
        self.mediaType = type
    }
    var body: some View {
        Text("")
    }
}
#endif
