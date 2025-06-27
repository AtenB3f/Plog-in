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

enum MediaType {
    case all
    case video
    case image
}

struct AssetData {
    init(type: MediaType, data: Any) {
        self.type = type
        if let video = data as? AVAsset {
            self.videoAsset = video
        }
        if let image = data as? UIImage {
            self.imageAsset = image
        }
    }
    
    var type: MediaType
    var videoAsset: AVAsset?
    var imageAsset: UIImage?
    var data: Any? {
        switch type {
        case .image:
            return imageAsset
        case .video:
            return videoAsset
        case .all:
            return nil
        }
    }
}

struct AssetPickerView: UIViewControllerRepresentable {
    @Binding var assetDatas: [AssetData]
    var mediaType: MediaType
    
    init(avAsset: Binding<[AssetData]>, type: MediaType) {
        self._assetDatas = avAsset
        self.mediaType = type
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 10
        if mediaType != .all {
            config.filter = mediaType == .video ? .videos : .images
        }
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: AssetPickerView
        
        init(_ parent: AssetPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            for result in results {
                guard let assetId = result.assetIdentifier else { return }
                
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                guard let phAsset = fetchResult.firstObject else { return }
                if phAsset.mediaType == .video {
                    PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil) { avAsset, _, _ in
                        guard let avAsset = avAsset else { return }
                        DispatchQueue.main.async {
                            let data = AssetData(type: .video, data: avAsset)
                            self.parent.assetDatas.append(data)
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
                        guard let image = image else { return }
                        let data = AssetData(type: .image, data: image)
                        self.parent.assetDatas.append(data)
                    }
                }
            }
        }
    }
}
