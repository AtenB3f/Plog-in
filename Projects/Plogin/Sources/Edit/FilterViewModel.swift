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
    
    func upscaleImage(image input: UIImage) -> UIImage? {
        let context = CIContext()
        let ciImage = CIImage(image: input)!
        
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
        
        return UIImage(cgImage: cgImage)
    }
    
    func resizeImageByFactor(_ image: UIImage, scaleFactor: CGFloat) -> UIImage? {
        let newSize = CGSize(width: image.size.width * scaleFactor,
                             height: image.size.height * scaleFactor)

        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
    
    func saveImage(_ image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                completion(false, NSError(domain: "PhotoAccess", code: 1, userInfo: [NSLocalizedDescriptionKey: "사진 접근 권한이 없습니다."]))
                return
            }

            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            completion(true, nil)
        }
    }
}
