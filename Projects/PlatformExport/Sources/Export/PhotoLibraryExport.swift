//
//  PhotoLibraryExport.swift
//  PlatformExport
//
//  Created by AtenB on 7/28/26.
//

import Photos
import PlatformCore
import CoreDomain

public class PhotoLibraryExport {
    private let crashReport: CrashReport?

    public init(
        crashReport: CrashReport? = nil
    ) {
        self.crashReport = crashReport
    }
}

private extension PhotoLibraryExport {
    func isAuthorized() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            return true
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return newStatus == .authorized || newStatus == .limited
        default:
            return false
        }
    }
}

extension PhotoLibraryExport: ImageExportRepository {
    public func save(images: [PImage]) async -> [Bool] {
        guard await isAuthorized() else {
            return images.map { _ in false }
        }

        var results: [Bool] = []
        for (index, image) in images.enumerated() {
            do {
                try await PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
                results.append(true)
            } catch {
                crashReport?.send(
                    title: "PhotoLibraryExport",
                    function: "save",
                    key: "PImage.index",
                    value: index,
                    error: error
                )
                results.append(false)
            }
        }
        return results
    }
}
