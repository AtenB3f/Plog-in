//
//  WatermarkSticker.swift
//  WatermarkFeature
//
//  Created by AtenB on 5/21/26.
//

import SwiftUI
import PlatformCore
import Design
import WatermarkDomain

struct WatermarkSticker: View {
    @EnvironmentObject var viewModel: WatermarkViewModel

    private let imageSize: CGSize

    @GestureState private var magnifyScale: CGFloat = 1.0
    @GestureState private var rotationAngle: Angle = .zero

    init(imageSize: CGSize) {
        self.imageSize = imageSize
    }

    var body: some View {
        GeometryReader { proxy in
            let renderRatio = viewModel.format.getRenderRatio(
                originSize: imageSize,
                renderSize: viewModel.format.getRenderSize(
                    watermarkSize: imageSize,
                    containerSize: proxy.size
                )
            )

            if viewModel.mode.stickerIndex != nil {
                stickerLayer(renderRatio: renderRatio)
                    .contentShape(Rectangle())
                    .simultaneousGesture(transformGesture)
            } else {
                stickerLayer(renderRatio: renderRatio)
            }
        }
        .onChange(of: viewModel.store.watermark.stickers.count) {
            if let selected = viewModel.mode.stickerIndex,
               selected >= viewModel.store.watermark.stickers.count {
                viewModel.action(.stickerMode(index: nil))
            }
        }
    }
}

private extension WatermarkSticker {
    @ViewBuilder
    func stickerLayer(renderRatio: CGFloat) -> some View {
        ZStack {
            ForEach(viewModel.store.watermark.stickers.indices, id: \.self) { index in
                StickerItemView(
                    sticker: Binding(
                        get: { viewModel.store.watermark.stickers[index] },
                        set: { viewModel.store.watermark.stickers[index] = $0 }
                    ),
                    renderRatio: renderRatio,
                    isSelected: viewModel.mode.stickerIndex == index,
                    activeMagnify: viewModel.mode.stickerIndex == index ? magnifyScale : 1.0,
                    activeRotation: viewModel.mode.stickerIndex == index ? rotationAngle : .zero,
                    onTap: { viewModel.action(.stickerMode(index: index)) }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var transformGesture: some Gesture {
        MagnifyGesture()
            .updating($magnifyScale) { value, state, _ in
                guard viewModel.mode.stickerIndex != nil else { return }
                state = value.magnification
            }
            .onEnded { value in
                guard let index = viewModel.mode.stickerIndex else { return }
                viewModel.store.watermark.stickers[index].scale *= value.magnification
            }
            .simultaneously(with:
                RotationGesture()
                    .updating($rotationAngle) { value, state, _ in
                        guard viewModel.mode.stickerIndex != nil else { return }
                        state = value
                    }
                    .onEnded { value in
                        guard let index = viewModel.mode.stickerIndex else { return }
                        viewModel.store.watermark.stickers[index].rotation += value.degrees
                    }
            )
    }
}

private struct StickerItemView: View {
    @Binding var sticker: WatermarkStickerModel
    let renderRatio: CGFloat
    let isSelected: Bool
    let activeMagnify: CGFloat
    let activeRotation: Angle
    let onTap: () -> Void

    @GestureState private var dragOffset: CGSize = .zero

    private var displayWidth: CGFloat {
        sticker.image.size.width * sticker.scale * renderRatio
    }

    private var displayHeight: CGFloat {
        sticker.image.size.height * sticker.scale * renderRatio
    }

    var body: some View {
        Image(pImage: sticker.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: displayWidth, height: displayHeight)
            .scaleEffect(activeMagnify)
            .overlay {
                if isSelected {
                    ZStack(alignment: .topTrailing) {
                        Rectangle()
                            .stroke(Color.white, lineWidth: 1.5)
                            .scaleEffect(activeMagnify)
                    }
                }
            }
            .rotationEffect(.degrees(sticker.rotation) + activeRotation)
            .opacity(Double(sticker.alpha))
            // position은 원본 좌표계로 저장되므로 renderRatio를 곱해 화면 좌표계로 변환
            .offset(
                x: sticker.position.x * renderRatio + dragOffset.width,
                y: sticker.position.y * renderRatio + dragOffset.height
            )
            // 드래그는 스티커 이미지 영역에서만 동작
            .simultaneousGesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        guard isSelected else { return }
                        state = value.translation
                    }
                    .onEnded { value in
                        guard isSelected else { return }
                        // 드래그 값은 화면 좌표계이므로 renderRatio로 나눠 원본 좌표계로 변환
                        sticker.position.x += value.translation.width / renderRatio
                        sticker.position.y += value.translation.height / renderRatio
                    }
            )
            .onTapGesture(perform: onTap)
    }
}
