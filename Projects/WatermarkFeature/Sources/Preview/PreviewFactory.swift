//
//  PreviewFactory.swift
//  WatermarkFeature
//

#if DEBUG
import PlatformExport
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
    // WatermarkEditViewModel.init이 store.watermark를 기본값으로 덮어쓰므로
    // 스타일 적용은 반드시 그 이후에 해야 한다.
    store.watermark.text = makePreviewWatermarkText(picker: picker, array: store.watermark.array)

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
    store.watermark.text = makePreviewWatermarkText(picker: picker, array: store.watermark.array)

    return WatermarkView(
        viewModel: WatermarkViewModel(
            picker: picker,
            stickerPicker: stickerPicker,
            store: store
        )
    )
}
#endif
