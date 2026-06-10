//
//  WatermarkEditType.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/19/26.
//

import SwiftUI
import Design
import PlatformCore

enum WatermarkEditPickerType {
    case picture
    case sticker
}

struct WatermarkItem {
    let id = UUID()
    var image: PImage
    var title: String?
    var size: CGFloat = 76
    
    init(image: PImage, title: String? = nil) {
        self.image = image
        self.title = title
    }
}

struct WatermarkListViewState {
    var select: Int?
    var mode: FrameListMode
    var list: [WatermarkItem]
    init(
        select: Int? = nil,
        mode: FrameListMode = .none,
        list: [WatermarkItem] = []
    ) {
        self.select = select
        self.mode = mode
        self.list = list
    }
}
