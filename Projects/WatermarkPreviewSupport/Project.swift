import ProjectDescription
import ProjectDescriptionHelpers

private let name = "WatermarkPreviewSupport"

private let project = Project(
    name: name,
    targets: [
        .target(
            name: name,
            destinations: ManifestShared.destinations,
            product: .framework,
            bundleId: ManifestShared.moduleBundleID(name),
            deploymentTargets: ManifestShared.deploymentTargets,
            infoPlist: .default,
            sources: ["Sources/**"],
            scripts: [ManifestShared.swiftLintScript],
            dependencies: [
                .project(target: "PlatformCore", path: .relativeToRoot("Projects/PlatformCore")),
                .project(target: "PlatformExport", path: .relativeToRoot("Projects/PlatformExport")),
                .project(target: "Design", path: .relativeToRoot("Projects/Design")),
                .project(target: "WatermarkDomain", path: .relativeToRoot("Projects/WatermarkDomain")),
            ],
            settings: ManifestShared.moduleSettings()
        )
    ]
)
