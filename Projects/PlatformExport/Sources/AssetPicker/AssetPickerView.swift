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
                return
            }
            
            picker.dismiss(animated: true)
            
            for result in results {
                guard let assetId = result.assetIdentifier else {
                    self.parent.picker.crashReport?.send(
                        title: "AssetPickerView",
                        function: "picker",
                        key: "assetIdentifier",
                        value: "nil",
                        error: AssetPickerError.missingAssetIdentifier
                    )
                    continue
                }

                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                guard let phAsset = fetchResult.firstObject else {
                    self.parent.picker.crashReport?.send(
                        title: "AssetPickerView",
                        function: "picker",
                        key: "assetIdentifier",
                        value: assetId,
                        error: AssetPickerError.assetNotFound
                    )
                    continue
                }
                if phAsset.mediaType == .video {
                    PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil) { avAsset, _, info in
                        guard let avAsset = avAsset,
                                let data = AssetData(type: .video, data: avAsset).videoAsset else {
                            self.parent.picker.crashReport?.send(
                                title: "AssetPickerView",
                                function: "requestAVAsset",
                                key: "assetIdentifier",
                                value: assetId,
                                error: (info?[PHImageErrorKey] as? Error) ?? AssetPickerError.videoLoadFailed
                            )
                            return
                        }
                        DispatchQueue.main.async {
                            self.parent.picker.videos.append(data)
                        }
                    }
                } else if phAsset.mediaType == .image {
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
                                self.parent.picker.crashReport?.send(
                                    title: "AssetPickerView",
                                    function: "requestImage",
                                    key: "assetIdentifier",
                                    value: assetId,
                                    error: (info?[PHImageErrorKey] as? Error) ?? AssetPickerError.imageLoadFailed
                                )
                                return
                            }
                            self.parent.picker.images.append(data)
                    }
                }
            }
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
