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
    "NSPhotoLibraryUsageDescription": "이미지 편집 및 생성을 위해 사진 및 영상 권한 허용이 필요합니다.",
    "ITSAppUsesNonExemptEncryption": false
]

// Firebase Crashlytics: 빌드마다 dSYM을 자동으로 업로드해 크래시 리포트가 심볼화되도록 함
private let firebaseCrashlyticsScript: TargetScript = .post(
    script: """
    if [ "${CONFIGURATION}" != "Release" ]; then
        echo "Debug 빌드: Crashlytics dSYM 업로드 건너뜀"
        exit 0
    fi
    "${BUILD_DIR%Build/*}SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
    """,
    name: "Firebase Crashlytics dSYM Upload",
    inputPaths: [
        "$(DWARF_DSYM_FOLDER_PATH)/$(DWARF_DSYM_FILE_NAME)/Contents/Resources/DWARF/$(TARGET_NAME)",
        "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
    ],
    basedOnDependencyAnalysis: false
)

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
            scripts: [ManifestShared.swiftLintScript, firebaseCrashlyticsScript],
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
