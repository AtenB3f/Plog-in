import ProjectDescription

let project = Project(
    name: "Plog-in",
    targets: [
        .target(
            name: "Plog-in",
            destinations: .iOS,
            product: .app,
            bundleId: "com.atenb.Plog-in",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Plog-in/Sources/**"],
            resources: ["Plog-in/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "Plog-inTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.Plog-inTests",
            infoPlist: .default,
            sources: ["Plog-in/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Plog-in")]
        ),
    ]
)
