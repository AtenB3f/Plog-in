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
                .project(target: "PlatformAdapter", path: .relativeToRoot("Projects/PlatformAdapter"))
            ],
            settings: ManifestShared.moduleSettings()
        )
    ]
)
