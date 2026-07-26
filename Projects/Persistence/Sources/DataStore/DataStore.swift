//
//  WatermarkDataStore.swift
//  Plogin
//
//  Created by AtenB on 10/23/25.
//  Copyright © 2025 AtenB. All rights reserved.
//
import Foundation
import SwiftData

public final class DataStore {
    private let context: ModelContext
    
    public init(modelContainer: ModelContainer) {
        self.context = ModelContext(modelContainer)
    }

#if DEBUG
    /// Preview / Debug 환경에서 손쉽게 사용하는 in-memory DataStore
    public convenience init() {
        do {
            let schema = Schema([
                WatermarkEntity.self,
                WatermarkWordEntity.self
            ])
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true
            )
            let container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
            self.init(modelContainer: container)
        } catch {
            fatalError("DataStore(Debug): in-memory ModelContainer 생성 실패: \(error)")
        }
    }
#endif

    public func save<T: PersistentModel>(model: T) {
        context.insert(model)
        do {
            try context.save()
        } catch {
            print("[\(T.self)] 저장 실패: \(error)")
        }
    }

    public func fetch<T: PersistentModel>(
        type: T.Type,
        predicate: Predicate<T>? = nil,
        sortBy: [SortDescriptor<T>] = []
    ) -> [T] {
        let descriptor = FetchDescriptor<T>(
            predicate: predicate,
            sortBy: sortBy
        )
        do {
            return try context.fetch(descriptor)
        } catch {
            print("[\(T.self)] 불러오기 실패: \(error)")
            return []
        }
    }
    
    public func delete<T: PersistentModel>(model: T) {
        context.delete(model)
        do {
            try context.save()
        } catch {
            print("[\(T.self)] 삭제 실패: \(error)")
        }
    }
}

extension DataStore {
    public static func makePersistent() throws -> DataStore {
        let schema = Schema([
            WatermarkEntity.self,
            WatermarkWordEntity.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        let container = try ModelContainer(for: schema, configurations: [configuration])
        return DataStore(modelContainer: container)
    }
}
