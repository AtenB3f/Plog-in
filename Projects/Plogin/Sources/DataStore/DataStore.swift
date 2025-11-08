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
    public static let shared: DataStore = {
        do {
            let container = try ModelContainer(
                for: WatermarkModel.self,
                WatermarkWordModel.self
            )
            return DataStore(modelContainer: container)
        } catch {
            fatalError("DataStore: ModelContainer 설정 실패: \(error)")
        }
    }()

    private let context: ModelContext
    
    private init(modelContainer: ModelContainer) {
        self.context = ModelContext(modelContainer)
    }

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
