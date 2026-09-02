import ProjectDescription
import ProjectDescriptionHelpers

private let name = "RenderEngine"

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
                .project(target: "CoreDomain", path: .relativeToRoot("Projects/CoreDomain")),
                .project(target: "WatermarkDomain", path: .relativeToRoot("Projects/WatermarkDomain")),
                .project(target: "PlatformCore", path: .relativeToRoot("Projects/PlatformCore")),
                .project(target: "PlatformExport", path: .relativeToRoot("Projects/PlatformExport"))
            ],
            settings: ManifestShared.moduleSettings()
        ),
        ManifestShared.unitTestTarget(for: name)
    ]
)
