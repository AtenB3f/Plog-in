//
//  LoadYoutubeView.swift
//  Plogin
//
//  Created by AtenB on 6/27/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import SwiftUI
import AVKit

struct LoadYoutubeView: View {
    @StateObject var viewModel = LoadYoutubeViewModel()
    
    var body: some View {
        if let videoUrl = viewModel.videoUrl, let player = viewModel.player {
            VideoPlayer(player: player)
                .frame(height: 300)
                .onAppear {
                    viewModel.setupAudioSession()
                    player.play()
                }
            
            Button("Download") {
                viewModel.saveVideoToAlbum(from: videoUrl, completion: { isSuccess, error in
                    print(error)
                })
            }
        }
        
        TextField("Youtube URL", text: $viewModel.text)
            .frame(maxWidth: .infinity)
        
        Button {
            print("click")
            Task {
                do {
                    try await viewModel.loadYoutube(url: viewModel.text)
                } catch {
                    print(error)
                }
            }

        } label: {
            Text("load")
        }
    }
}
