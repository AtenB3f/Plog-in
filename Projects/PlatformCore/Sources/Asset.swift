//
//  Asset.swift
//  Plogin
//
//  Created by AtenB on 8/9/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import AVKit

public enum MediaType {
    case all
    case video
    case image
}

public struct AssetData: Hashable {
    public init(type: MediaType, data: Any) {
        self.type = type
        if let video = data as? AVAsset {
            self.videoAsset = video
        }
        if let image = data as? PImage {
            self.imageAsset = image
        }
    }
    
    public var type: MediaType
    public var videoAsset: AVAsset?
    public var imageAsset: PImage?
    public var data: Any? {
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
