//
//  AssetPicker.swift
//  PlatformExport
//
//  Created by AtenB on 5/15/26.
//

import Foundation
import PlatformCore

public class AssetPicker: ObservableObject {
    @Published public var assets: [AssetData] = []
    var mediaType: MediaType
    var limit: Int
    
    public init(
        mediaType: MediaType,
        limit: Int
    ) {
        self.mediaType = mediaType
        self.limit = limit
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
            return 30
        case .sticker:
            return 10
        }
    }
    
    var mediaType: MediaType {
        return .image
    }
}
