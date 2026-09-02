//
//  AssetPicker.swift
//  PlatformExport
//
//  Created by AtenB on 5/15/26.
//

import Foundation
import AVFoundation
import PlatformCore
import CoreDomain

public class AssetPicker: ObservableObject {
    @Published public var videos: [AVAsset] = []
    @Published public var images: [PImage] = []
    var mediaType: MediaType
    var limit: Int
    let crashReport: CrashReport?

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
}
