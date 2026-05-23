//
//  WatermarkEditType.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/19/26.
//

import Foundation
import Design
import PlatformCore

enum WatermarkEditPickerType {
    case picture
    case sticker
}

struct WatermarkEditItem: TitleImagable {
    let id = UUID()
    var image: PImage?
    var title: String?
    var size: CGFloat = 76
    
    init(image: PImage?) {
        self.image = image
    }
}

struct WatermarkEditListViewState {
    var select: Int?
    var mode: FrameListMode
    var images: [PImage]
    var list: [WatermarkEditItem]
    init(
        select: Int? = nil,
        mode: FrameListMode = .none,
        images: [PImage] = [],
        list: [WatermarkEditItem] = []
    ) {
        self.select = select
        self.mode = mode
        self.images = images
        self.list = list
    }
}
