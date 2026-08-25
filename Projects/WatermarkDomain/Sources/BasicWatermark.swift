//
//  BasicWatermark.swift
//  Plogin
//
//  Created by AtenB on 11/8/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

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
    
    public var description: String {
        switch self {
        case .melonStreaming:
            return "멜론에서 저장한 스트리밍 카드에 \n워터마크를 넣은 인증미지 만들기"
        case .melonWeekly:
            return "주간 인기상 투표 화면을 캡쳐하여\n인증 이미지 만들기"
        case .youtubeStreaming:
            return "영상의 시작과 끝 화면을 캡쳐한 두 장의 \n이미지를 합쳐 하나의 인증 이미지 만들기"
        }
    }
}

public extension BasicWatermarkType {
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
                ),
                stickers: [],
                array: .init(type: .none, rows: 2, columns: 1),
                export: .init(type: .auto, width: 650, height: 650),
                frame: .init(title: self.title, code: self.rawValue)
            )
        }
    }
}
