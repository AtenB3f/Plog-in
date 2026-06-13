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
                guard let assetId = result.assetIdentifier else { return }
                
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                guard let phAsset = fetchResult.firstObject else { return }
                if phAsset.mediaType == .video {
                    PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil) { avAsset, _, _ in
                        guard let avAsset = avAsset,
                                let data = AssetData(type: .video, data: avAsset).videoAsset else { return }
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
                        options: options) { image, _ in
                            guard let image = image,
                                    let data = AssetData(type: .image, data: image).imageAsset else { return }
                            self.parent.picker.images.append(data)
                    }
                }
            }
        }
    }
}
#elseif os(macOS)
// TODO: macOS 전용
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
