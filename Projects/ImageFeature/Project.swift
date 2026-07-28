import ProjectDescription
import ProjectDescriptionHelpers

private let name = "ImageFeature"

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
                .project(target: "RenderEngine", path: .relativeToRoot("Projects/RenderEngine")),
                .project(target: "Design", path: .relativeToRoot("Projects/Design"))
            ],
            settings: ManifestShared.moduleSettings()
        )
    ]
)
