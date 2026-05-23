//
//  FilterViewModel.swift
//  Plogin
//
//  Created by AtenB on 6/6/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import Design
import PlatformCore

enum FilterDataType {
    case noiseLevel
    case noiseSharpness
    case sharpness
    case colorBrightness
    case colorContrast
    case colorSaturation
    
    func range(_ x: Float = 1.0) -> ClosedRange<Float> {
        switch self {
        case .noiseLevel:
            return 0...(0.1*x)
        case .noiseSharpness:
            return 0...(1.0*x)
        case .sharpness:
            return 0...(2.0*x)
        case .colorBrightness:
            return 0.5...(1.5*x)
        case .colorContrast:
            return -0.2...(0.2*x)
        case .colorSaturation:
            return 0.5...(1.5*x)
        }
    }
}

struct FilterData: Equatable {
    var noiseLevel: Float = .zero
    var noiseSharpness: Float = .zero
    
    var sharpness: Float = .zero
    
    var colorBrightness: Float = .zero
    var colorContrast: Float = 1.0
    var colorSaturation: Float = 1.0
}

class FilterViewModel: ObservableObject {
    @Published var filterData = FilterData()
    
    func upscaleImage(image input: PImage) -> PImage? {
        let context = CIContext()
        
#if os(iOS)
        guard let ciImage = CIImage(image: input) else { return nil }
#elseif os(macOS)
        guard let cgImage = input.cgImage(forProposedRect: nil, context: nil, hints: nil),
              let ciImage = CIImage(cgImage: cgImage) as CIImage? else { return nil }
#endif
        
        // 1. 노이즈 제거
        let noiseFilter = CIFilter.noiseReduction()
        noiseFilter.inputImage = ciImage
        noiseFilter.noiseLevel = filterData.noiseLevel
        noiseFilter.sharpness = filterData.sharpness
        
        // 2. 선명도 향상
        let sharpenFilter = CIFilter.sharpenLuminance()
        sharpenFilter.inputImage = noiseFilter.outputImage
        sharpenFilter.sharpness = filterData.sharpness
        
        // 3. (선택) 컬러 보정
        let colorFilter = CIFilter.colorControls()
        colorFilter.inputImage = sharpenFilter.outputImage
        colorFilter.brightness = filterData.colorBrightness
        colorFilter.contrast = filterData.colorContrast
        colorFilter.saturation = filterData.colorSaturation
        
        // 렌더링
        guard let output = colorFilter.outputImage,
              let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        
#if os(iOS)
        return UIImage(cgImage: cgImage)
#elseif os(macOS)
        return NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
        #endif
    }
    
    func resizeImageByFactor(_ image: PImage, scaleFactor: CGFloat) -> PImage? {
        let newSize = CGSize(width: image.size.width * scaleFactor,
                             height: image.size.height * scaleFactor)
        
#if os(iOS)
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
#elseif os(macOS)
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        image.draw(in: CGRect(origin: .zero, size: newSize),
                   from: CGRect(origin: .zero, size: image.size),
                   operation: .copy,
                   fraction: 1.0)
        newImage.unlockFocus()
        return newImage
#endif
    }
    
    func saveImage(_ image: PImage, completion: @escaping (Bool, Error?) -> Void) {
#if os(iOS)
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                completion(false, NSError(domain: "PhotoAccess", code: 1, userInfo: [NSLocalizedDescriptionKey: "사진 접근 권한이 없습니다."]))
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            completion(true, nil)
        }
#elseif os(macOS)
        // macOS: NSSavePanel 사용
        DispatchQueue.main.async {
            let savePanel = NSSavePanel()
            savePanel.allowedContentTypes = [.png, .jpeg]
            savePanel.nameFieldStringValue = "edited_image.png"
            
            savePanel.begin { response in
                guard response == .OK, let url = savePanel.url else {
                    completion(false, NSError(domain: "SavePanel", code: 2, userInfo: [NSLocalizedDescriptionKey: "저장이 취소되었습니다."]))
                    return
                }
                
                guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                    completion(false, NSError(domain: "ImageConversion", code: 3, userInfo: [NSLocalizedDescriptionKey: "이미지 변환에 실패했습니다."]))
                    return
                }
                
                let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
                guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
                    completion(false, NSError(domain: "ImageExport", code: 4, userInfo: [NSLocalizedDescriptionKey: "이미지 내보내기에 실패했습니다."]))
                    return
                }
                
                do {
                    try pngData.write(to: url)
                    completion(true, nil)
                } catch {
                    completion(false, error)
                }
            }
        }
#endif
    }
}
