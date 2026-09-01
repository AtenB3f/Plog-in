import ProjectDescription
import ProjectDescriptionHelpers

private let name = "Persistence"

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
            resources: ["Resources/**"],
            scripts: [ManifestShared.swiftLintScript],
            dependencies: [
                .project(target: "CoreDomain", path: .relativeToRoot("Projects/CoreDomain")),
                .project(target: "WatermarkDomain", path: .relativeToRoot("Projects/WatermarkDomain"))
            ],
            settings: ManifestShared.moduleSettings()
        )
    ]
)
