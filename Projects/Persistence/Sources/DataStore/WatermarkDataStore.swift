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
    
    public init() {
        do {
            let schema = Schema([
                WatermarkEntity.self,
                WatermarkWordEntity.self
            ])
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            let container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
            self.store = DataStore(modelContainer: container)
        } catch {
            fatalError("DataStore(Debug): in-memory ModelContainer 생성 실패: \(error)")
        }
    }
}

// MARK: - Watermark Word
extension WatermarkDataStore: WatermarkWordRepository {
    public func getWords() -> [WatermarkWordModel] {
        let list = store.fetch(type: WatermarkWordEntity.self)
        return list.map { $0.toModel }
    }
    
    public func setWord(_ text: String) {
        let list = getWords()
        if list.count >= 10 {
            if let first = list.first?.toEntity {
                store.delete(model: first)
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
/*
extension WatermarkDataStore {
    /// curstom 워터마크
    func getWatermark(_ frameTitle: String) -> WatermarkEntity? {
        let list = getWatermarks()
        if let data = list.first(where: { $0.frameSetting.title == frameTitle
            && $0.frameSetting.type == WatermarkFrameType.custom}) {
            return data
        }
        return nil
    }
    
    /// Basic 워터마크
    func getWatermark(type: BasicWatermarkType) -> WatermarkEntity? {
        let watermarkName = type.rawValue
        let list = store.fetch(
            type: WatermarkEntity.self,
            predicate: #Predicate<WatermarkEntity>{
                $0.frameSetting.title == watermarkName
            }
        )
        
        return list.filter { $0.frameSetting.type == WatermarkFrameType.basic }.first
    }
}

public extension WatermarkDataStore {
    func installBasicWatermark() {
        let frame = WatermarkFrameType.basic
        let list = store.fetch(
            type: WatermarkEntity.self,
            predicate: #Predicate<WatermarkEntity>{ $0.frameSetting.type == frame })
        
        for type in BasicWatermarkType.allCases {
            let watermark = list.first(where: { $0.frameSetting.title == type.rawValue })
            if watermark == nil {
                store.save(model: type.watermark.toEntity)
            }
        }
    }
}
*/
