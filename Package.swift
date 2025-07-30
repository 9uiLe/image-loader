// swift-tools-version: 6.2

import PackageDescription

// MARK: - Plugin

let runMockoloPlugin = Target.PluginUsage.plugin(
    name: "RunMockolo",
    package: "run-mockolo"
)

// MARK: - Source

let model = Target.target(name: "Model")

let interface = Target.target(
    name: "Interface",
    dependencies: [
        model
    ]
)

let core = Target.target(
    name: "Core",
    dependencies: [
        model,
        interface
    ]
)

// MARK: - Package

let package = Package.package(
    name: "image-loader",
    platforms: [
        .iOS(.v18)
    ],
    dependencies: [
        .package(url: "https://github.com/9uiLe/run-mockolo", exact: "1.0.2")
    ],
    targets: [
        model,
        interface,
        core
    ],
    testTargets: []
)

// MARK: - Target Extension

extension Target {
    private var dependency: Target.Dependency {
        .target(name: name, condition: nil)
    }

    fileprivate func library(targets: [Target] = []) -> Product {
        .library(name: name, targets: [name] + targets.map(\.name))
    }

    static func target(
        name: String,
        path: String = "Sources/",
        dependencies: [Target] = [],
        dependencyLibraries: [Target.Dependency] = [],
        resources: [Resource] = [],
        plugins: [Target.PluginUsage] = [],
        swiftLanguageMode: SwiftLanguageMode = .v6
    ) -> Target {
        .target(
            name: name,
            dependencies: dependencies.map(\.dependency) + dependencyLibraries,
            path: path + name,
            resources: resources,
            swiftSettings: [
                .swiftLanguageMode(swiftLanguageMode)
            ],
            plugins: plugins
        )
    }

    static func testTarget(
        name: String,
        dependencies: [Target],
        swiftLanguageMode: SwiftLanguageMode = .v6
    ) -> Target {
        .testTarget(
            name: name,
            dependencies: dependencies.map(\.dependency),
            swiftSettings: [
                .swiftLanguageMode(swiftLanguageMode)
            ]
        )
    }
}

// MARK: - Package Extension

extension Package {
    static func package(
        name: String,
        platforms: [SupportedPlatform],
        dependencies: [Dependency] = [],
        targets: [Target],
        testTargets: [Target]
    ) -> Package {
        Package(
            name: name,
            defaultLocalization: "ja",
            platforms: platforms,
            products: targets.map { $0.library() },
            dependencies: dependencies,
            targets: targets + testTargets
        )
    }
}
