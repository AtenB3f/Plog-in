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

// MARK: - 워터마크 스티커 레이어
struct WatermarkSticker: View {
    @EnvironmentObject var viewModel: WatermarkViewModel

    private let imageSize: CGSize
    private let magnify: CGFloat
    private let rotation: Angle
    private let drag: CGSize

    init(
        imageSize: CGSize,
        magnify: CGFloat,
        rotation: Angle,
        drag: CGSize
    ) {
        self.imageSize = imageSize
        self.magnify = magnify
        self.rotation = rotation
        self.drag = drag
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
            stickerLayer(renderRatio: renderRatio, containerSize: proxy.size)
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
    func stickerLayer(renderRatio: CGFloat, containerSize: CGSize) -> some View {
        ZStack {
            ForEach(viewModel.store.watermark.stickers.indices, id: \.self) { index in
                let isSelected = viewModel.mode.stickerIndex == index
                let fallback = viewModel.store.watermark.stickers[index]

                StickerItem(
                    sticker: Binding(
                        get: {
                            viewModel.store.watermark.stickers.indices.contains(index)
                                ? viewModel.store.watermark.stickers[index]
                                : fallback
                        },
                        set: { newValue in
                            guard viewModel.store.watermark.stickers.indices.contains(index) else { return }
                            viewModel.store.watermark.stickers[index] = newValue
                        }
                    ),
                    renderRatio: renderRatio,
                    magnify: isSelected ? magnify : 1.0,
                    rotation: isSelected ? rotation : .zero,
                    drag: isSelected ? drag : .zero,
                    onTap: { viewModel.action(.stickerMode(index: index)) }
                )
            }
        }
        .frame(width: containerSize.width, height: containerSize.height)
    }
}

// MARK: - 개별 스티커
private struct StickerItem: View {
    @Binding var sticker: WatermarkStickerModel
    let renderRatio: CGFloat
    let magnify: CGFloat
    let rotation: Angle
    let drag: CGSize
    let onTap: () -> Void

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
            .scaleEffect(magnify)
            .rotationEffect(.degrees(sticker.rotation) + rotation)
            .opacity(Double(sticker.alpha))
            .offset(
                x: sticker.position.x * renderRatio + drag.width,
                y: sticker.position.y * renderRatio + drag.height
            )
            .onTapGesture(perform: onTap)
    }
}
