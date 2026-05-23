import ProjectDescription
import ProjectDescriptionHelpers

private let name = "Design"

private let infoPlist: [String: Plist.Value] = [
    "UIAppFonts": [
        "Pretendard-Bold.ttf",
        "Pretendard-SemiBold.ttf",
        "Pretendard-Regular.ttf"
    ]
]

private let project = Project(
    name: name,
    organizationName: ManifestShared.organization,
    options: .options(
        defaultKnownRegions: ["ko"],
        developmentRegion: "ko"
    ),
    targets: [
        .target(
            name: name,
            destinations: ManifestShared.destinations,
            product: .framework,
            bundleId: ManifestShared.moduleBundleID(name),
            deploymentTargets: ManifestShared.deploymentTargets,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: [ManifestShared.swiftLintScript],
            dependencies: [
                .project(target: "PlatformCore", path: .relativeToRoot("Projects/PlatformCore")),
                .project(target: "UISchema", path: .relativeToRoot("Projects/UISchema"))
            ],
            settings: ManifestShared.moduleSettings()
        )
    ]
)
