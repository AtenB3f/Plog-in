import ProjectDescription
import ProjectDescriptionHelpers

private let name = "API"

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
            settings: ManifestShared.moduleSettings()
        )
    ]
)
