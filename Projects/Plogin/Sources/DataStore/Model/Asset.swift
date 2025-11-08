//
//  Asset.swift
//  Plogin
//
//  Created by AtenB on 8/9/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import Design
import AVKit

enum MediaType {
    case all
    case video
    case image
}

struct AssetData: Hashable {
    init(type: MediaType, data: Any) {
        self.type = type
        if let video = data as? AVAsset {
            self.videoAsset = video
        }
        if let image = data as? PImage {
            self.imageAsset = image
        }
    }
    
    var type: MediaType
    var videoAsset: AVAsset?
    var imageAsset: PImage?
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
