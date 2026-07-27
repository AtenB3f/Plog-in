//
//  Workspace.swift
//  Manifests
//
//  Created by AtenB on 3/15/25.
//

import ProjectDescription

let workspace = Workspace(
    name: "Plogin",
    projects: [
        .relativeToRoot("Projects/Plogin"),
        .relativeToRoot("Projects/Design"),
        .relativeToRoot("Projects/UISchema"),
        .relativeToRoot("Projects/Utility"),
        .relativeToRoot("Projects/CoreDomain"),
        .relativeToRoot("Projects/WatermarkDomain"),
        .relativeToRoot("Projects/Persistence"),
        .relativeToRoot("Projects/PlatformCore"),
        .relativeToRoot("Projects/PlatformExport"),
        .relativeToRoot("Projects/RenderEngine"),
        .relativeToRoot("Projects/WatermarkFeature"),
        .relativeToRoot("Projects/WatermarkPreviewSupport"),
        .relativeToRoot("Projects/ImageFeature"),
        .relativeToRoot("Projects/VideoFeature"),
//        .relativeToRoot("Projects/API")
    ]
)
