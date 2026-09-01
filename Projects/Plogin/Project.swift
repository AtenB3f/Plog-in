import ProjectDescription
import ProjectDescriptionHelpers

private let name = "Plogin"

private let infoPlist: [String: Plist.Value] = [
    "CFBundleDisplayName": "\(name)",
    "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
    "CFBundleURLSchemes": ["plogin"],
    "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
    "UIUserInterfaceStyle": "Light",
    "UIRequiresFullScreen": true,
    "UILaunchStoryboardName": "LaunchScreen",
    "CFBundleURLTypes": [
        [
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": ["Plogin"]
        ]
    ],
    "NSPhotoLibraryUsageDescription": "사진 및 영상 권한"
]

private let project = Project(
    name: name,
    organizationName: ManifestShared.organization,
    options: .options(
        defaultKnownRegions: ["ko"],
        developmentRegion: "ko"
    ),
    packages: [
        .package(url: "https://github.com/alexeichhorn/YouTubeKit", .upToNextMajor(from: "0.2.9")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "12.18.0"))
    ],
    targets: [
        .target(
            name: name,
            destinations: ManifestShared.destinations,
            product: .app,
            bundleId: ManifestShared.appBundleID,
            deploymentTargets: ManifestShared.deploymentTargets,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .dictionary([:]),
            scripts: [ManifestShared.swiftLintScript],
            dependencies: [
                .package(product: "YouTubeKit"),
                .package(product: "FirebaseCrashlytics"),
                .project(target: "Design", path: .relativeToRoot("Projects/Design")),
                .project(target: "CoreDomain", path: .relativeToRoot("Projects/CoreDomain")),
                .project(target: "WatermarkDomain", path: .relativeToRoot("Projects/WatermarkDomain")),
                .project(target: "Persistence", path: .relativeToRoot("Projects/Persistence")),
                .project(target: "PlatformCore", path: .relativeToRoot("Projects/PlatformCore")),
                .project(target: "RenderEngine", path: .relativeToRoot("Projects/RenderEngine")),
                .project(target: "WatermarkFeature", path: .relativeToRoot("Projects/WatermarkFeature")),
                .project(target: "ImageFeature", path: .relativeToRoot("Projects/ImageFeature")),
                .project(target: "VideoFeature", path: .relativeToRoot("Projects/VideoFeature"))
            ],
            settings: ManifestShared.appSettings()
        )
    ]
)
