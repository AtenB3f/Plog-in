//
//  LoadYoutubeViewModel.swift
//  Plogin
//
//  Created by AtenB on 6/27/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
import Photos

class LoadYoutubeViewModel: ObservableObject {
    let youtubeManager = YoutubeManager.shared
    
    @Published var player: AVPlayer?
    @Published var text: String = "https://www.youtube.com/shorts/UlOdzehLcZ0"
    //https://www.youtube.com/shorts/UlOdzehLcZ0
    // https://www.youtube.com/shorts/UlOdzehLcZ0?feature=share
    @Published var videoUrl: URL?
    
    func loadYoutube(url: String) async throws {
        guard let stream = try await youtubeManager.getYoutubeVideo(url: url) else { return }
        print(stream.videoResolution ?? "")
        await MainActor.run {
            videoUrl = stream.url
            
            player = AVPlayer(url: stream.url)
            player?.isMuted = false
            player?.volume = 1.0
            
        }
        
        // https://youtu.be/5eCFXT6Gnio
    }
    
    func setupAudioSession() {
#if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession 설정 실패: \(error)")
        }
#elseif os(macOS)
        // TODO: 
#endif
    }
    
    
    func saveVideoToAlbum(from remoteURL: URL, completion: @escaping (Bool, Error?) -> Void) {
        // 1. 다운로드할 위치 설정
        let tempDirectory = FileManager.default.temporaryDirectory
        let localURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".mp4")

        // 2. URLSession으로 다운로드
        URLSession.shared.downloadTask(with: remoteURL) { (downloadedURL, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }

            guard let downloadedURL = downloadedURL else {
                DispatchQueue.main.async {
                    completion(false, NSError(domain: "Download failed", code: -1))
                }
                return
            }

            do {
                // 3. 파일 복사 (다운로드된 위치에서 temp로)
                try FileManager.default.moveItem(at: downloadedURL, to: localURL)

                // 4. 사진 앨범에 저장 (PHPhotoLibrary)
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: localURL)
                }) { success, error in
                    DispatchQueue.main.async {
                        completion(success, error)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }.resume()
    }
}
