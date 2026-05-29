//
//  WatermarkEditMenuType.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/26/26.
//

import SwiftUI
import WatermarkDomain

enum WatermarkMenuType: String, CaseIterable {
    case text
    case sticker
    case array
    case export
    case frame
    
    var menuName: String {
        switch self {
        case .text:
            return "텍스트"
        case .sticker:
            return "스티커"
        case .array:
            return "배열"
        case .export:
            return "출력"
        case .frame:
            return "프레임"
        }
    }
}

public enum WatermarkEditMenuType {
    case text(_ menu: TextMenu)
    case sticker(_ menu: StickerMenu)
    case array(_ menu: ArrayMenu)
    case export(_ menu: ExportMenu)
    case frame(_ menu: FrameMenu)
    
    public enum TextMenu {
        case word(_ text: String)
        case color(_ color: Color)
        case date
        case gradient
    }
    
    public enum StickerMenu {
        case load
        case edit
        case remove
    }
    
    public enum ArrayMenu {
        case toggle
        case type(_ type: WatermarkArrayType)
        case order
    }
    
    public enum ExportMenu {
        case type(_ type: WatermarkExportType)
    }
    
    public enum FrameMenu {
        case save
        case title
    }
}
