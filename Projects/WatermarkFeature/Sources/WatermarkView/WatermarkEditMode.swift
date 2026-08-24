//
//  WatermarkEditMode.swift
//  WatermarkFeature
//
//  Created by AtenB on 8/24/26.
//

import SwiftUI
import PlatformCore
import Design
import WatermarkDomain

// MARK: - 워터마크 편집모드 레이어
struct WatermarkEditMode: View {
    @EnvironmentObject var viewModel: WatermarkViewModel

    private let watermarkImageSize: CGSize

    @GestureState private var textRotation: Angle = .zero
    @GestureState private var stickerMagnify: CGFloat = 1.0
    @GestureState private var stickerRotation: Angle = .zero
    @GestureState private var stickerDrag: CGSize = .zero

    init(watermarkImageSize: CGSize) {
        self.watermarkImageSize = watermarkImageSize
    }

    var body: some View {
        GeometryReader { proxy in
            let renderRatio = viewModel.format.getRenderRatio(
                originSize: watermarkImageSize,
                renderSize: viewModel.format.getRenderSize(
                    watermarkSize: watermarkImageSize,
                    containerSize: proxy.size
                )
            )
            let layout = viewModel.makeWatermarkTextLayout(
                watermarkImageSize: watermarkImageSize,
                containerSize: proxy.size
            )
            
            switch viewModel.mode {
            case .none:
                content(renderRatio: renderRatio, layout: layout)
            case .text:
                content(renderRatio: renderRatio, layout: layout)
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.action(.textMode) }
                    .gesture(textRotationGesture)
            case .sticker:
                content(renderRatio: renderRatio, layout: layout)
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.action(.textMode) }
                    .simultaneousGesture(stickerTransformGesture(renderRatio: renderRatio))
            }
        }
    }
}

private extension WatermarkEditMode {
    @ViewBuilder
    func content(renderRatio: CGFloat, layout: WatermarkTextLayout?) -> some View {
        ZStack {
            WatermarkText(
                watermarkImageSize: watermarkImageSize,
                rotation: textRotation
            )
            WatermarkSticker(
                imageSize: watermarkImageSize,
                magnify: stickerMagnify,
                rotation: stickerRotation,
                drag: stickerDrag
            )
        }
        .overlay {
            guides(renderRatio: renderRatio, layout: layout)
                .allowsHitTesting(false)
        }
    }

    @ViewBuilder
    func guides(renderRatio: CGFloat, layout: WatermarkTextLayout?) -> some View {
        switch viewModel.mode {
        case .none:
            EmptyView()
        case .text:
            if let layout {
                textGuide(renderTextAreaSize: layout.renderTextAreaSize)
            }
        case .sticker(let index):
            if index < viewModel.store.watermark.stickers.count {
                stickerGuide(viewModel.store.watermark.stickers[index], renderRatio: renderRatio)
            }
        }
    }

    @ViewBuilder
    func textGuide(renderTextAreaSize size: CGSize) -> some View {
        Rectangle()
            .stroke(lineWidth: 2)
            .foreground(.white)
            .shadow(.light)
            .frame(width: size.width, height: size.height)
            .rotationEffect(.degrees(viewModel.store.watermark.text.rotation) + textRotation)
    }

    @ViewBuilder
    func stickerGuide(_ sticker: WatermarkStickerModel, renderRatio: CGFloat) -> some View {
        Rectangle()
            .stroke(Color.white, lineWidth: 1.5)
            .frame(
                width: sticker.image.size.width * sticker.scale * renderRatio,
                height: sticker.image.size.height * sticker.scale * renderRatio
            )
            .scaleEffect(stickerMagnify)
            .rotationEffect(.degrees(sticker.rotation) + stickerRotation)
            .offset(
                x: sticker.position.x * renderRatio + stickerDrag.width,
                y: sticker.position.y * renderRatio + stickerDrag.height
            )
    }
}

// MARK: 편집모드 제스처
private extension WatermarkEditMode {
    /// 텍스트 제스처: 회전 동작
    var textRotationGesture: some Gesture {
        RotationGesture()
            .updating($textRotation) { value, state, _ in
                state = value
            }
            .onEnded { value in
                viewModel.store.watermark.text.rotation += value.degrees
            }
    }

    /// 스티커 제스처: 확대 + 회전 + 이동
    /// 이미지 전체 영역에서 동작하
    func stickerTransformGesture(renderRatio: CGFloat) -> some Gesture {
        let drag = DragGesture()
            .onEnded { value in
                guard let index = viewModel.mode.stickerIndex else { return }
                // 드래그 값은 화면 좌표계이므로 renderRatio로 나눠 원본 좌표계로 변환
                let translation = limitTranslation(value.translation, renderRatio: renderRatio)
                viewModel.store.watermark.stickers[index].position.x += translation.width / renderRatio
                viewModel.store.watermark.stickers[index].position.y += translation.height / renderRatio
            }
        let magnify = MagnifyGesture()
            .onEnded { value in
                guard let index = viewModel.mode.stickerIndex else { return }
                viewModel.store.watermark.stickers[index].scale *= value.magnification
            }
        let rotate = RotationGesture()
            .onEnded { value in
                guard let index = viewModel.mode.stickerIndex else { return }
                viewModel.store.watermark.stickers[index].rotation += value.degrees
            }

        return drag
            .simultaneously(with: magnify.simultaneously(with: rotate))
            .updating($stickerDrag) { value, state, _ in
                state = limitTranslation(value.first?.translation ?? .zero, renderRatio: renderRatio)
            }
            .updating($stickerMagnify) { value, state, _ in
                state = value.second?.first?.magnification ?? 1.0
            }
            .updating($stickerRotation) { value, state, _ in
                state = value.second?.second ?? .zero
            }
    }

    // 스티커 이동 시 위치 제한 값 계산 반영
    func limitTranslation(_ translation: CGSize, renderRatio: CGFloat) -> CGSize {
        guard renderRatio > 0,
              let index = viewModel.mode.stickerIndex,
              index < viewModel.store.watermark.stickers.count
        else { return .zero }

        let origin = viewModel.store.watermark.stickers[index].position
        let target = viewModel.format.limitStickerPosition(
            CGPoint(
                x: origin.x + translation.width / renderRatio,
                y: origin.y + translation.height / renderRatio
            ),
            watermarkImageSize: watermarkImageSize
        )
        return CGSize(
            width: (target.x - origin.x) * renderRatio,
            height: (target.y - origin.y) * renderRatio
        )
    }
}
