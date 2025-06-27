//
//  ShowMediaView.swift
//  Plogin
//
//  Created by AtenB on 6/6/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import AVKit

struct ShowMediaView: View {
    @EnvironmentObject var viewModel: AssetViewModel
    
    @Binding var index: Int
    
    var body: some View {
        VStack {
            if viewModel.assets.count > index {
                if viewModel.assets[index].type == .video {
                    if let urlAsset = viewModel.assets[index].data as? AVURLAsset {
                        VideoPlayer(player: AVPlayer(url: urlAsset.url))
                            .frame(height: 300)
                    }
                } else if let image = viewModel.assets[index].data as? UIImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                }
            }
            
            Button(">") {
                index += 1
                if viewModel.assets.count <= index {
                    index = 0
                }
            }
        }
    }
}
