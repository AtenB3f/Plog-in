//
//  Project.swift
//  Manifests
//
//  Created by AtenB on 3/15/25.
//

import ProjectDescription
import Foundation

private let name = "VideoModule"
private let appName = "Media.VideoModule"
private let organization = "AtenB"
private let bundleID = "com.\(organization).\(name)"
private let infoPlist: [String: Plist.Value] = [:]
private let dependencies: [TargetDependency]  = []
private let packages: [Package] = []
private let scripts: [TargetScript] = [
    .pre(script: """
            ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")

            ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
            """
         ,
         name: "SwiftLint",
         basedOnDependencyAnalysis: false
        )
]

let projectVideo = Project(
    name: name,
    packages: packages,
    targets: [
        .target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: bundleID,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: scripts,
            dependencies: dependencies
        )
    ]
)
