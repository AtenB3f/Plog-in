//
//  WatermarkEditVIewModel.swift
//  Plogin
//
//  Created by AtenB on 8/13/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import UIKit
import SwiftUI

class WatermarkEditVIewModel: ObservableObject {
    @Published var index: Int = 0
    @Published var inputText: String = "Hello"
    @Published var textSize: CGFloat = 60
    @Published var textColor: Color = .blue
    @Published var textOpacity: CGFloat = 1.0
    @Published var backgroundColor: Color = .clear
    @Published var backgroundOpacity: CGFloat = 1.0
    @Published var spacing: CGSize = CGSize(width: 200, height: 80)
    @Published var generatedImage: [UIImage] = []
    
    let editer = ImageEditManager()
    
    func generatedImage(_ origin: UIImage, index: Int) {
        guard generatedImage.count > index else { return }
        
        let newImage = editer.drawRepeatedTextOnImage(
          image: origin,
          text: inputText,
          textColor: .purple,
          font: .systemFont(ofSize: textSize),
          spacing: spacing)
         generatedImage[index] = newImage
    }
    
    func generatedImageAll(_ origin: [UIImage]) {
        if generatedImage.count != origin.count {
            generatedImage.removeAll()
            generatedImage = origin
        }
        for index in 0..<origin.count {
            let newImage = editer.drawRepeatedTextOnImage(
              image: origin[index],
              text: inputText,
              textColor: textColor.toUI(textOpacity),
              font: .systemFont(ofSize: textSize),
              spacing: spacing)
             generatedImage[index] = newImage
        }
    }
}
