//
//  BasicWatermark.swift
//  Plogin
//
//  Created by AtenB on 11/8/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import Design

enum BasicWatermarkType: String, CaseIterable {
    case melonStreaming     = "Melon_Streaming"
    case melonWeekly        = "Melon_Weekly"
    case youtubeStreaming   = "Youtube_Streaming"
    
    var title: String {
        switch self {
        case .melonStreaming:
            return "멜론 스트리밍 카드"
        case .melonWeekly:
            return "멜론 주간 인기상"
        case .youtubeStreaming:
            return "유튜브 스트리밍"
        }
    }
    
    var description: String {
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

extension BasicWatermarkType {
    var watermark: WatermarkModel {
        let fontSize: CGFloat = 32
        let name = FontType.body1.fontName
        
        switch self {
        case .melonStreaming:
            return .init(
                textSetting: .init(text: "",
                                   fontName: name,
                                   fontSize: 24,
                                   rotation: -20.0,
                                   color: .Gray.medium,
                                   alpha: 0.3,
                                   spacing: .init(width: 20, height: 10),
                                   isGradient: true,
                                   isDate: true),
                stickers: [],
                arraySetting: .init(type: .none, rows: 1, columns: 1),
                exportSetting: .init(type: .auto, size: .init(width: 650, height: 650)),
                frameSetting: .init(title: self.rawValue, type: .basic)
            )
        case .melonWeekly:
            return .init(
                textSetting: .init(text: "",
                                   fontName: name,
                                   fontSize: fontSize,
                                   rotation: -20.0,
                                   color: .white,
                                   alpha: 0.2,
                                   spacing: .init(width: 100, height: 50),
                                   isGradient: true,
                                   isDate: true),
                stickers: [],
                arraySetting: .init(type: .none, rows: 1, columns: 1),
                exportSetting: .init(type: .auto, size: .zero),
                frameSetting: .init(title: self.rawValue, type: .basic)
            )
        case .youtubeStreaming:
            return .init(
                textSetting: .init(text: "",
                                   fontName: name,
                                   fontSize: fontSize,
                                   rotation: -20.0,
                                   color: .white,
                                   alpha: 0.2,
                                   spacing: .init(width: 100, height: 50),
                                   isGradient: true,
                                   isDate: true),
                stickers: [],
                arraySetting: .init(type: .none, rows: 1, columns: 1),
                exportSetting: .init(type: .auto, size: .zero),
                frameSetting: .init(title: self.rawValue, type: .basic)
            )
        }
    }
}

extension DataStore {
    func installBasicWatermark() {
        let frame = WatermarkFrameType.basic
        let list = fetch(
            type: WatermarkModel.self,
            predicate: #Predicate<WatermarkModel>{ $0.frameSetting.type == frame })
        
        for type in BasicWatermarkType.allCases {
            let watermark = list.first(where: { $0.frameSetting.title == type.rawValue })
            if watermark == nil {
                save(model: type.watermark)
            }
        }
    }
}
