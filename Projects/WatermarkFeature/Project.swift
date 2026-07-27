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
                .project(target: "PlatformCore", path: .relativeToRoot("Projects/PlatformCore")),
                .project(target: "PlatformExport", path: .relativeToRoot("Projects/PlatformExport")),
                .project(target: "Design", path: .relativeToRoot("Projects/Design")),
                .project(target: "UISchema", path: .relativeToRoot("Projects/UISchema")),
                .project(target: "WatermarkDomain", path: .relativeToRoot("Projects/WatermarkDomain")),
                .project(target: "RenderEngine", path: .relativeToRoot("Projects/RenderEngine")),
                .project(target: "WatermarkPreviewSupport", path: .relativeToRoot("Projects/WatermarkPreviewSupport")),
            ],
            settings: ManifestShared.moduleSettings()
        )
    ]
)
