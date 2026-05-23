import ProjectDescription
import ProjectDescriptionHelpers

private let name = "PlatformCore"

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
            dependencies: [],
            settings: ManifestShared.moduleSettings()
        )
    ]
)
