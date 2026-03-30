//
//  Workspace.swift
//  Manifests
//
//  Created by AtenB on 3/15/25.
//

import ProjectDescription

let workspace = Workspace(name: "Plogin",
                          projects: [
                            .relativeToRoot("Projects/Plogin"),
                            .relativeToRoot("Projects/Design"),
                            .relativeToRoot("Projects/Utility"),
                            .relativeToRoot("Projects/CoreDomain"),
                            .relativeToRoot("Projects/Persistence"),
                            .relativeToRoot("Projects/PlatformAdapter"),
                            .relativeToRoot("Projects/RenderEngine"),
                            .relativeToRoot("Projects/WatermarkFeature"),
                            .relativeToRoot("Projects/ImageFeature"),
                            .relativeToRoot("Projects/VideoFeature"),
//                            .relativeToRoot("Projects/API")
                          ])
