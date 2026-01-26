// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    products: [
        .library(
            name: "BuildTools",
            targets: ["BuildTools"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/SimplyDanny/SwiftLintPlugins.git",
            exact: "0.63.1"
        )
    ],
    targets: [
        .target(
            name: "BuildTools"
        )
    ]
)
