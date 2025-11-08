//
//  WatermarkDataStore.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import Design

// MARK: - WatermarkWord
extension DataStore {
    func loadWatermarkWord() -> [WatermarkWordModel] {
        let list = fetch(type: WatermarkWordModel.self)
        print(list.map{ $0.text })
        return list
    }
    
    func saveWatermarkWord(_ text: String) {
        let list = loadWatermarkWord()
        if list.count >= 10 {
            if let first = list.first {
                delete(model: first)
            }
        }
        let data = WatermarkWordModel(text: text)
        save(model: data)
    }
    
    func deleteWatermarkWord(_ text: String) {
        if let model = loadWatermarkWord().first(where: { $0.text == text }) {
            delete(model: model)
        }
    }
}

    // MARK: - Watermark
extension DataStore {
    func loadWatermark() -> [WatermarkModel] {
        let list = fetch(type: WatermarkModel.self)
        print(list)
        return list
    }
    
    func saveWatermark(_ watermark: WatermarkModel) {
        save(model: watermark)
    }
    
    func deleteWatermark(_ id: UUID) {
        if let model = loadWatermark().first(where: { $0.id == id }) {
            delete(model: model)
        }
    }
    
    func getWatermark(_ frameTitle: String) -> WatermarkModel? {
        let list = loadWatermark()
        if let data = list.first(where: { $0.frameSetting.title == frameTitle
            && $0.frameSetting.type == WatermarkFrameType.custom.rawValue}) {
            return data
        }
        return nil
    }
    
    func getWatermark(type: BasicWatermarkType) -> WatermarkModel? {
        let watermarkName = type.rawValue
        let typeName = WatermarkFrameType.basic.rawValue
        let list = fetch(
            type: WatermarkModel.self,
            predicate: #Predicate<WatermarkModel>{
                $0.frameSetting.type == typeName && $0.frameSetting.title == watermarkName
            }
        )
        return list.first
    }
}
