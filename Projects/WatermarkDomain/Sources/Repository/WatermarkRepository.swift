//
//  WatermarkRepository.swift
//  WatermarkDomain
//
//  Created by AtenB on 7/4/26.
//

import Foundation

public protocol WatermarkWordRepository {
    func getWords() -> [WatermarkWordModel]
    func setWord(_ text: String)
    func removeWord(_ text: String)
    func removeLast()
}

public protocol WatermarkRepository {
    func getWatermarks() -> [WatermarkModel]
    func setWatermark(_ watermark: WatermarkModel)
    func removeWatermark(_ id: UUID)
    func getWatermarks(type: WatermarkFrameType) -> [WatermarkModel]
}
