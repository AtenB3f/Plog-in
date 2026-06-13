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
                    originSize: imageSize,
                    containerSize: proxy.size
                )
            )

            ZStack {
                ForEach(viewModel.store.watermark.stickers.indices, id: \.self) { index in
                    StickerItemView(
                        sticker: Binding(
                            get: { viewModel.store.watermark.stickers[index] },
                            set: { viewModel.store.watermark.stickers[index] = $0 }
                        ),
                        renderRatio: renderRatio,
                        isSelected: viewModel.selectedStickerIndex == index,
                        activeMagnify: viewModel.selectedStickerIndex == index ? magnifyScale : 1.0,
                        activeRotation: viewModel.selectedStickerIndex == index ? rotationAngle : .zero,
                        onTap: { viewModel.action(.stickerMode(index: index)) },
                        onClose: { viewModel.action(.stickerMode(index: nil)) }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            // 확대/축소 + 회전은 이미지 전체 영역에서 동작
            .simultaneousGesture(
                MagnifyGesture()
                    .updating($magnifyScale) { value, state, _ in
                        guard viewModel.selectedStickerIndex != nil else { return }
                        state = value.magnification
                    }
                    .onEnded { value in
                        guard let index = viewModel.selectedStickerIndex else { return }
                        viewModel.store.watermark.stickers[index].scale *= value.magnification
                    }
                    .simultaneously(with:
                        RotationGesture()
                            .updating($rotationAngle) { value, state, _ in
                                guard viewModel.selectedStickerIndex != nil else { return }
                                state = value
                            }
                            .onEnded { value in
                                guard let index = viewModel.selectedStickerIndex else { return }
                                viewModel.store.watermark.stickers[index].rotation += value.degrees
                            }
                    )
            )
        }
        .onChange(of: viewModel.store.watermark.stickers.count) {
            if let selected = viewModel.selectedStickerIndex,
               selected >= viewModel.store.watermark.stickers.count {
                viewModel.action(.stickerMode(index: nil))
            }
        }
    }
}

private struct StickerItemView: View {
    @Binding var sticker: WatermarkStickerModel
    let renderRatio: CGFloat
    let isSelected: Bool
    let activeMagnify: CGFloat
    let activeRotation: Angle
    let onTap: () -> Void
    let onClose: () -> Void

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
            .overlay {
                if isSelected {
                    ZStack(alignment: .topTrailing) {
                        Rectangle()
                            .stroke(Color.white, lineWidth: 1.5)

                        Image.iconCloseCircle
                            .frame(width: 20, height: 20)
                            .background {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 20, height: 20)
                            }
                            .foreground(.Gray.light)
                            .offset(x: 10, y: -10)
                            .onTapGesture(perform: onClose)
                    }
                }
            }
            .scaleEffect(activeMagnify)
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
