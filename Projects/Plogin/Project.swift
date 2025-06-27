//
//  Project.swift
//  Manifests
//
//  Created by AtenB on 3/15/25.
//

import ProjectDescription
import Foundation

private let name = "Plogin"
private let displayName = "Plog-in"
private let organization = "Plli"
private let bundleID = "com.\(organization).\(name)"
private let version = "0.0.0"
private let buildVersion = "1"
private let infoPlist: [String: Plist.Value] = [
    "CFBundleDisplayName": "\(displayName)",
    "CFBundleVersion": "\(buildVersion)",
    "CFBundleShortVersionString": "\(version)",
    "NSPhotoLibraryUsageDescription": "사진 및 영상 권한"
]
private let dependencies: [TargetDependency]  = [
    .package(product: "YouTubeKit")
]
private let packages: [Package] = [
    .package(url: "https://github.com/alexeichhorn/YouTubeKit", .upToNextMajor(from: "0.2.6"))
]
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

let project = Project(
    name: name,
    organizationName: organization,
    packages: packages,
    targets: [
        .target(
            name: name,
            destinations: .iOS,
            product: .app,
            productName: name,
            bundleId: bundleID,
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: scripts,
            dependencies: dependencies
        )
    ]
)
