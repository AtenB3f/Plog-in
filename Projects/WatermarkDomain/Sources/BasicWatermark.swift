//
//  BasicWatermark.swift
//  Plogin
//
//  Created by AtenB on 11/8/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import PlatformCore
import Foundation

public enum BasicWatermarkType: String, CaseIterable {
    case melonStreaming     = "Melon_Streaming"
    case melonWeekly        = "Melon_Weekly"
    case youtubeStreaming   = "Youtube_Streaming"
    
    public var title: String {
        switch self {
        case .melonStreaming:
            return "멜론 스트리밍 카드"
        case .melonWeekly:
            return "멜론 주간 인기상"
        case .youtubeStreaming:
            return "유튜브 스트리밍"
        }
    }
}

public extension BasicWatermarkType {
    func watermark(thumnail: PImage) -> WatermarkModel {
        var data = self.watermark
        data.frame.thumbnailData = thumnail.pngData()
        return data
    }
    
    var watermark: WatermarkModel {
        switch self {
        case .melonStreaming:
            return .init(
                text: .init(
                    fontSize: 36,
                    rotation: -30,
                    color: .init(red: 1, green: 1, blue: 1, opacity: 0.25),
                    spacingWidthRatio: 0.25,
                    spacingHeightRatio: 0.25,
                    date: Date()
                ),
                stickers: [],
                array: .init(type: .none, rows: 1, columns: 1),
                export: .init(type: .auto, width: 650, height: 650),
                frame: .init(title: self.title, code: self.rawValue)
            )
        case .melonWeekly:
            return .init(
                text: .init(
                    fontSize: 36,
                    rotation: -30,
                    color: .init(red: 1, green: 1, blue: 1, opacity: 0.25),
                    spacingWidthRatio: 0.25,
                    spacingHeightRatio: 0.25,
                    date: Date()
                ),
                stickers: [],
                array: .init(type: .none, rows: 1, columns: 1),
                export: .init(type: .auto, width: 650, height: 650),
                frame: .init(title: self.title, code: self.rawValue)
            )
        case .youtubeStreaming:
            return .init(
                text: .init(
                    rotation: -30,
                    color: .init(red: 1, green: 1, blue: 1, opacity: 0.25),
                    spacingWidthRatio: 0.25,
                    spacingHeightRatio: 0.25,
                    date: Date()
                ),
                stickers: [],
                array: .init(type: .vertical, rows: 2, columns: 1),
                export: .init(type: .auto, width: 650, height: 650),
                frame: .init(title: self.title, code: self.rawValue)
            )
        }
    }
}
