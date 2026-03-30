import ProjectDescription
import ProjectDescriptionHelpers

private let name = "WatermarkFeature"

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
                .project(target: "RenderEngine", path: .relativeToRoot("Projects/RenderEngine")),
                .project(target: "Design", path: .relativeToRoot("Projects/Design"))
            ],
            settings: ManifestShared.moduleSettings()
        )
    ]
)
