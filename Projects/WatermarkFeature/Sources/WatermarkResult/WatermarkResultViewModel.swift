//
//  WatermarkResultViewModel.swift
//  WatermarkFeature
//
//  Created by AtenB on 7/28/26.
//

import Foundation
import Combine
import PlatformCore
import WatermarkDomain
import RenderEngine

public class WatermarkResultViewModel: ObservableObject {
    public enum ViewState {
        case loading
        case content
    }
    public enum Action {
        case appear
        case save
    }
    
    @Published var viewState: ViewState = .loading
    @Published var preview: [PImage] = []
    @Published var indexPreview: Int = 0
    
    // Watermark Flow Step
    var editor: WatermarkEditor
    let usecase: WatermarkUsecase
    
    private let stepSubject = PassthroughSubject<WatermarkFlowStep, Never>()
    public var step: AnyPublisher<WatermarkFlowStep, Never> { stepSubject.eraseToAnyPublisher() }
    
    public init(
        editor: WatermarkEditor,
        watermarkUsecase: WatermarkUsecase
    ) {
        self.editor = editor
        self.usecase = watermarkUsecase
    }
}

public extension WatermarkResultViewModel {
    func action(_ action: Action) {
        Task {
            switch action {
            case .appear:
                await appear()
            case .save:
                await save()
            }
        }
    }
}

@MainActor
private extension WatermarkResultViewModel {
    func appear() async {
        do {
            async let delay: () = Task.sleep(for: .seconds(1))
            async let make: () = makePreview()
            _ = try await (delay, make)
            viewState = .content
        } catch {
            debugPrint(error)
        }
    }
    
    func save() async {
        saveWatermarkImage()
        stepSubject.send(.resultFinished)
    }
}

@MainActor
private extension WatermarkResultViewModel {
    func makePreview() {
        preview = editor.generateWatermarks()
    }
    
    func saveWatermarkImage() {
        guard !preview.isEmpty else { return }
        Task {
            _ = await usecase.saveWatermarkImage(preview)
        }
    }
}
