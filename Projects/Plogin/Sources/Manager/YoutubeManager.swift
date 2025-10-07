//
//  YoutubeManager.swift
//  Plogin
//
//  Created by AtenB on 6/27/25.
//  Copyright © 2025 Plli. All rights reserved.
//

import YouTubeKit
import Foundation

class YoutubeManager {
    static let shared = YoutubeManager()
    
    func extractVideoID(from url: URL) -> String? {
        let urlString = url.absoluteString

        // Case 1: youtube.com/watch?v=VIDEO_ID
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            if let v = queryItems.first(where: { $0.name == "v" })?.value {
                return v
            }
        }

        // Case 2: youtu.be/VIDEO_ID
        if url.host?.contains("youtu.be") == true {
            return url.pathComponents.dropFirst().first
        }

        // Case 3: youtube.com/embed/VIDEO_ID
        if url.pathComponents.contains("embed") {
            if let index = url.pathComponents.firstIndex(of: "embed"), index + 1 < url.pathComponents.count {
                return url.pathComponents[index + 1]
            }
        }

        // Case 4: youtube.com/shorts/VIDEO_ID
        if url.pathComponents.contains("shorts") {
            if let index = url.pathComponents.firstIndex(of: "shorts"), index + 1 < url.pathComponents.count {
                return url.pathComponents[index + 1]
            }
        }

        return nil
    }

    func getYoutubeVideo(url: String) async throws -> YouTubeKit.Stream? {
        
        guard let url = URL(string: url) else { return nil }
        guard let videoID = extractVideoID(from: url) else { return nil }
        let video = YouTube(videoID: videoID, methods: [.local])
        let stream = try await video.streams
            .filterVideoAndAudio()
            .filter { $0.isNativelyPlayable }
            .highestResolutionStream()
        return stream
    }
}
