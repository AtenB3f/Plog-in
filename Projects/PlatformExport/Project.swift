import ProjectDescription
import ProjectDescriptionHelpers

private let name = "PlatformExport"

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
                .project(target: "CoreDomain", path: .relativeToRoot("Projects/CoreDomain"))
            ],
            settings: ManifestShared.moduleSettings()
        )
    ]
)
