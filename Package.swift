// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "image-loader",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "ImageLoader", targets: ["ImageLoader"])
    ],
    dependencies: [
        .package(url: "https://github.com/9uiLe/run-mockolo", exact: "1.0.3")
    ],
    targets: [
        .target(
            name: "ImageLoader",
            dependencies: [],
            plugins: [
                .plugin(name: "RunMockolo", package: "run-mockolo")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
