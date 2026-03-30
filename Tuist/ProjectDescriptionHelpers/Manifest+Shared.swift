import ProjectDescription
import Foundation

public enum ManifestShared {
    public static let organization = "AtenB"
    public static let appName = "Plogin"
    public static let appBundleID = "plli.\(organization).\(appName)"

    public static let iOSVersion = "17.0"
    public static let macOSVersion = "14.0"
    public static let destinations: Destinations = [.iPhone, .iPad, .mac, .macCatalyst]
    public static let deploymentTargets: DeploymentTargets = .multiplatform(iOS: iOSVersion, macOS: macOSVersion)

    public static let marketingVersion = "0.0.1"
    public static let buildVersion = "1"
    public static let teamID = "MHP823U965"

    public static func moduleBundleID(_ module: String) -> String {
        "\(appBundleID).\(module)"
    }

    public static var swiftLintScript: TargetScript {
        .pre(
            script: """
            ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
            ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
            """,
            name: "SwiftLint",
            basedOnDependencyAnalysis: false
        )
    }

    public static func appSettings() -> Settings {
        .settings(
            base: [
                "MARKETING_VERSION": "\(marketingVersion)",
                "CURRENT_PROJECT_VERSION": "\(buildVersion)",
                "DEVELOPMENT_TEAM": "\(teamID)",
                "CODE_SIGN_STYLE": "Automatic",
            ],
            configurations: [
                .debug(name: "Debug", settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "CODE_SIGN_IDENTITY": "Apple Development",
                ]),
                .release(name: "Release", settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE",
                    "CODE_SIGN_IDENTITY": "Apple Distribution",
                ]),
            ]
        )
    }

    public static func moduleSettings() -> Settings {
        .settings(
            base: [
                "MARKETING_VERSION": "\(marketingVersion)",
                "CURRENT_PROJECT_VERSION": "\(buildVersion)",
            ],
            configurations: [
                .debug(name: "Debug", settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                ]),
                .release(name: "Release", settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE",
                ]),
            ]
        )
    }
}
