//
//  WatermarkDataStore.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//

import Foundation
import SwiftData
import WatermarkDomain

public class WatermarkDataStore {
    var store: DataStore

    public init(store: DataStore) {
        self.store = store
    }
}

// MARK: - Watermark Word
extension WatermarkDataStore: WatermarkWordRepository {
    public func getWords() -> [WatermarkWordModel] {
        let list = store.fetch(
            type: WatermarkWordEntity.self,
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return list.map { $0.toModel }
    }
    
    public func setWord(_ text: String) {
        let list = getWords()
        if list.count >= 10 {
            if let oldest = list.last?.toEntity {
                store.delete(model: oldest)
            }
        }
        let data = WatermarkWordEntity(text: text)
        store.save(model: data)
    }
    
    public func removeWord(_ text: String) {
        if let model = getWords().first(where: { $0.text == text })?.toEntity {
            store.delete(model: model)
        }
    }
    
    public func removeLast() {
        let list = store.fetch(type: WatermarkWordEntity.self)
        if let last = list.last {
            store.delete(model: last)
        }
    }
}

// MARK: - Watermark
extension WatermarkDataStore: WatermarkRepository {
    public func getWatermarks() -> [WatermarkModel] {
        let list = store.fetch(type: WatermarkEntity.self)
        return list.map { $0.toModel }
    }
    
    public func getWatermark(id: UUID) -> WatermarkModel? {
        let list = store.fetch(type: WatermarkEntity.self)
        return list.first(where: { $0.id == id })?.toModel
    }
    
    public func setWatermark(_ watermark: WatermarkModel) {
        store.save(model: watermark.toEntity)
    }
    
    public func removeWatermark(_ id: UUID) {
        if let entity = getWatermarks().first(where: { $0.id == id })?.toEntity {
            store.delete(model: entity)
        }
    }
    
    public func getWatermarks(type: WatermarkFrameType) -> [WatermarkModel] {
        let list = store.fetch(type: WatermarkEntity.self)
        return list.filter { $0.frameSetting.type == type }.map { $0.toModel }
    }
}
