//
//  Project.swift
//  Manifests
//
//  Created by AtenB on 3/15/25.
//

import ProjectDescription
import Foundation

private let releaseVersion: String = "0.0.1"
private let buildVersion: String = "1"
private let projectName: String = "Design"
private let appScheme: String = "plogin"
private let organization: String = "AtenB"
private let bundleID: String = "com.AtenB."
private let iOSMinimumVersion: String = "16.0"
private let macOSMinimumVersion: String = "13.0"

private enum TargetType: String, CaseIterable {
    case plogin = "Plogin"
    case design = "Design"
    case api = "API"
    case imageModule = "ImageModule"
    case videoModule = "VideoModule"
    case utility = "Utility"
}

extension TargetType {
    var targetName: String {
        return self.rawValue
    }

    var targetBundleID: String {
        switch self {
        case .plogin:
            return bundleID + projectName
        default:
            return bundleID + projectName + "." + self.rawValue
        }
    }

    var getTarget: Target {
        switch self {
        case .plogin:
            return .target(
                name: targetName,
                destinations: [.iPhone, .iPad, .mac, .macCatalyst],
                product: .app,
                bundleId: targetBundleID,
                deploymentTargets: .multiplatform(iOS: iOSMinimumVersion, macOS: macOSMinimumVersion),
                infoPlist: .extendingDefault(with: getInfoPlist),
                sources: ["Sources/**"],
                resources: ["Resources/**"],
                entitlements: .dictionary(getEntitlements),
                scripts: scripts,
                dependencies: getTargetDependency,
                settings: getSettings
            )
        default:
            return .target(
                name: targetName,
                destinations: [.iPhone, .iPad, .mac, .macCatalyst],
                product: .framework,
                bundleId: targetBundleID,
                deploymentTargets: .multiplatform(iOS: iOSMinimumVersion, macOS: macOSMinimumVersion),
                infoPlist: .extendingDefault(with: getInfoPlist),
                sources: ["Sources/**"],
                resources: ["Resources/**"],
                entitlements: .dictionary(getEntitlements),
                dependencies: getTargetDependency,
                settings: getSettings
            )
        }
    }

    var getTargetDependency: [TargetDependency] {
        switch self {
        case .plogin:
            return [
                .package(product: "YouTubeKit"),
                .target(TargetType.design.getTarget),
                .target(TargetType.api.getTarget),
                .target(TargetType.utility.getTarget),
                .target(TargetType.imageModule.getTarget),
                .target(TargetType.videoModule.getTarget)
            ]
        default:
            return []
        }
    }

    var getInfoPlist: [String: Plist.Value] {
        switch self {
        case .plogin:
            return [
                "CFBundleDisplayName": "\(projectName)",
                "CFBundleIdentifier": "\(targetBundleID)",
                "CFBundleVersion": "\(buildVersion)",
                "CFBundleShortVersionString": "\(releaseVersion)",
                "CFBundleURLSchemes": [
                    "\(appScheme)"
                ],
                "NSAppTransportSecurity": [
                    "NSAllowsArbitraryLoads": true
                ],
                "UIUserInterfaceStyle": "Light",
                "UIRequiresFullScreen": true,
                "UILaunchStoryboardName": "LaunchScreen",
                "CFBundleURLTypes": [
                    "CFBundleTypeRole": "Editor",
                    "CFBundleURLSchemes": [
                        "\(projectName)"
                    ]
                ],
                "NSPhotoLibraryUsageDescription": "사진 및 영상 권한"
            ]
        default:
            return [
                "CFBundleDisplayName": "\(projectName)",
                "CFBundleIdentifier": "\(targetBundleID)",
                "UIAppFonts": [
                    "Pretendard-Bold.ttf",
                    "Pretendard-SemiBold.ttf",
                    "Pretendard-Regular.ttf"
                ],
            ]
        }
    }
    
    var getEntitlements: [String: Plist.Value] {
        switch self {
        default:
            return [:]
        }
    }
    
    var getSettings: Settings {
        switch self {
        default:
            return .settings(
                base: [
                    "MARKETING_VERSION": "\(releaseVersion)",
                    "CURRENT_PROJECT_VERSION": "\(buildVersion)"
                ],
                configurations: [
                    .debug(name: "Debug", settings: [
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG"
                    ]),
                    .release(name: "Release", settings: [
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE"
                    ])
                ]
            )
        }
    }
    
    var scripts: [TargetScript] {
        return [
            .pre(
               script: """
               ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
               ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
               """,
               name: "SwiftLint",
               basedOnDependencyAnalysis: false
              )
        ]
    }
}

private let packages: [Package] = [
    .package(url: "https://github.com/alexeichhorn/YouTubeKit", .upToNextMajor(from: "0.2.9"))
]

let projectDesign = Project(
    name: TargetType.design.targetName,
    organizationName: organization,
    options: .options(
        defaultKnownRegions: ["ko"],
        developmentRegion: "ko"
    ),
    packages: packages,
    targets: [TargetType.design].map { $0.getTarget },
    schemes: []
)
