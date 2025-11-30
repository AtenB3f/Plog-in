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
//                            .relativeToRoot("Projects/Network"),
//                            .relativeToRoot("Projects/ImageModule"),
//                            .relativeToRoot("Projects/VideoModule")
                          ])
