//
//  WatermarkEditorPreview.swift
//  WatermarkFeature
//

#if DEBUG
import SwiftUI
import PlatformCore
import PlatformExport
import WatermarkDomain
import RenderEngine
import WatermarkPreviewSupport

func makePreviewWatermarkEditView() -> WatermarkEditView {
    let usecase = makePreviewWatermarkUsecase()
    let picker = AssetPicker(mediaType: .image, limit: 10)
    picker.images = [makePreviewImage()]
    let stickerPicker = AssetPicker(mediaType: .image, limit: 10)
    let store = WatermarkStore()

    let editViewModel = WatermarkEditViewModel(
        popup: WatermarkPopupCoordinator(),
        usecase: usecase,
        picker: picker,
        stickerPicker: stickerPicker,
        store: store
    )
    store.setText(makePreviewWatermarkText(picker: picker, array: store.watermark.array))

    return WatermarkEditView(
        viewModel: editViewModel,
        watermarkViewModel: WatermarkViewModel(
            picker: picker,
            stickerPicker: stickerPicker,
            store: store
        )
    )
}

func makePreviewWatermarkView() -> WatermarkView {
    let picker = AssetPicker(mediaType: .image, limit: 10)
    picker.images = [makePreviewImage()]
    let stickerPicker = AssetPicker(mediaType: .image, limit: 10)
    let store = WatermarkStore()
    store.setText(makePreviewWatermarkText(picker: picker, array: store.watermark.array))

    return WatermarkView(
        viewModel: WatermarkViewModel(
            picker: picker,
            stickerPicker: stickerPicker,
            store: store
        )
    )
}

private struct WatermarkEditorComparisonView: View {
    let watermarkView: WatermarkView
    let exportedImage: PImage?

    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 8) {
                Text("SwiftUI Preview")
                    .foregroundColor(.white)
                watermarkView
                    .frame(height: 300)
            }
            VStack(spacing: 8) {
                Text("Export")
                    .foregroundColor(.white)
                if let exportedImage {
                    Image(pImage: exportedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                } else {
                    Text("생성 실패")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

private func makeWatermarkEditorComparisonView() -> WatermarkEditorComparisonView {
    let picker = AssetPicker(mediaType: .image, limit: 10)
    picker.images = [makePreviewImage()]
    let stickerPicker = AssetPicker(mediaType: .image, limit: 10)
    let store = WatermarkStore()
    var text = makePreviewWatermarkText(picker: picker, array: store.watermark.array)
    text.gradientColors = [Color.Yejun.main, Color.Noah.main, Color.Bamby.main, Color.Eunho.main, Color.Hamin.main].map { ColorData($0, alpha: 0.3) }
    text.date = Date()
    store.setText(text)
    store.setExport(WatermarkFormat().makeExportModel(origins: picker.images, array: store.watermark.array))

    let watermarkView = WatermarkView(
        viewModel: WatermarkViewModel(picker: picker, stickerPicker: stickerPicker, store: store)
    )

    let editor = WatermarkEditor(watermark: store.watermark, origins: picker.images)
    let exportedImage = editor.generateWatermarks().first

    return WatermarkEditorComparisonView(watermarkView: watermarkView, exportedImage: exportedImage)
}

#Preview {
    makeWatermarkEditorComparisonView()
}
#endif
