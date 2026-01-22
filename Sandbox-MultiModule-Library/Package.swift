// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sandbox-MultiModule-Library",
    platforms: [.iOS(.v26)],
    products: [
        .library(
            name: "Sandbox-MultiModule-Library",
            targets: [
                Target.application.name,
                Target.Adapter.driven.name,
                Target.Feature.repositoryDetail.name,
                Target.Feature.searchRepository.name
            ]
        ),
    ],
    dependencies: [
        .swiftDependencies,
        .swiftOpenAPIGenerator,
        .swiftOpenAPIRuntime,
        .swiftOpenAPIURLSession
    ],
    targets: [
        .application,
        .designSystem,
        .domain,
        .featureBuilder,
        .Adapter.driven,
        .Feature.searchRepository,
        .Feature.repositoryDetail,
        .Infra.gitHubAPI,
        .Port.driving,
        .Port.driven,
        .Tests.application,
        .Tests.Adapter.driven
    ]
)

extension Target {
    enum Adapter {}
    enum Feature {}
    enum Infra {}
    enum Port {}

    enum Tests {
        enum Adapter {}
    }
}

extension Target.Dependency {
    enum Adapter {}
    enum ExternalLibrary {}
    enum Infra {}
    enum Port {}
}

extension Target.PluginUsage {
    enum ExternalLibrary {}
}

// MARK: - Application
extension Target {
    static var application: Target {
        .target(
            name: "Application",
            dependencies: [
                .domain,
                .ExternalLibrary.dependencies,
                .Port.driving,
                .Port.driven
            ],
            path: "Sources/Application",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var designSystem: Target {
        .target(
            name: "DesignSystem",
            path: "Sources/DesignSystem",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var domain: Target {
        .target(
            name: "Domain",
            path: "Sources/Domain",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var featureBuilder: Target {
        .target(
            name: "FeatureBuilder",
            dependencies: [
                .domain,
                .ExternalLibrary.dependencies,
                .ExternalLibrary.dependenciesMacros
            ],
            path: "Sources/FeatureBuilder",
            swiftSettings: .allUpcomingFeatures
        )
    }
}


extension Target.Dependency {
    static var application: Target.Dependency {
        .target(name: Target.application.name)
    }

    static var designSystem: Target.Dependency {
        .target(name: Target.designSystem.name)
    }

    static var domain: Target.Dependency {
        .target(name: Target.domain.name)
    }

    static var featureBuilder: Target.Dependency {
        .target(name: Target.featureBuilder.name)
    }
}

// MARK: - Adapter
extension Target.Adapter {
    static var driven: Target {
        .target(
            name: "DrivenAdapter",
            dependencies: [
                .domain,
                .Infra.gitHubAPI,
                .ExternalLibrary.dependencies,
                .Port.driven
            ],
            path: "Sources/Adapter/Driven",
            swiftSettings: .allUpcomingFeatures
        )
    }
}

extension Target.Dependency.Adapter {
    static var driven: Target.Dependency {
        .target(name: Target.Adapter.driven.name)
    }
}

// MARK: - Feature
extension Target.Feature {
    static var searchRepository: Target {
        .target(
            name: "SearchRepositoryFeature",
            dependencies: [
                .designSystem,
                .domain,
                .featureBuilder,
                .ExternalLibrary.dependencies,
                .Port.driving
            ],
            path: "Sources/Feature/SearchRepository",
            swiftSettings: .forFeatureTarget
        )
    }

    static var repositoryDetail: Target {
        .target(
            name: "RepositoryDetailFeature",
            dependencies: [
                .designSystem,
                .domain,
                .featureBuilder,
                .ExternalLibrary.dependencies,
                .Port.driving
            ],
            path: "Sources/Feature/RepositoryDetail",
            swiftSettings: .forFeatureTarget
        )
    }
}

// MARK: - Infra
extension Target.Infra {
    // 自動生成されるコードがUpcoming Featureに未対応のため、swiftSettingsを指定しない
    // https://github.com/apple/swift-openapi-generator/issues/777
    static var gitHubAPI: Target {
        .target(
            name: "GitHubAPI",
            dependencies: [
                .ExternalLibrary.dependencies,
                .ExternalLibrary.openAPIRuntime,
                .ExternalLibrary.openAPIURLSession
            ],
            path: "Sources/Infra/GitHubAPI",
            plugins: [
                .ExternalLibrary.openAPIGenerator
            ]
        )
    }
}

extension Target.Dependency.Infra {
    static var gitHubAPI: Target.Dependency {
        .target(name: Target.Infra.gitHubAPI.name)
    }
}

// MARK: - Port
extension Target.Port {
    static var driving: Target {
        .target(
            name: "DrivingPort",
            dependencies: [
                .domain,
                .ExternalLibrary.dependencies,
                .ExternalLibrary.dependenciesMacros
            ],
            path: "Sources/Port/Driving",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var driven: Target {
        .target(
            name: "DrivenPort",
            dependencies: [
                .domain,
                .ExternalLibrary.dependencies,
                .ExternalLibrary.dependenciesMacros
            ],
            path: "Sources/Port/Driven",
            swiftSettings: .allUpcomingFeatures
        )
    }
}

extension Target.Dependency.Port {
    static var driving: Target.Dependency {
        .target(name: Target.Port.driving.name)
    }

    static var driven: Target.Dependency {
        .target(name: Target.Port.driven.name)
    }
}

// MARK: - Tests
extension Target.Tests {
    static var application: Target {
        .testTarget(
            name: "ApplicationTests",
            dependencies: [.application],
            path: "Tests/Application",
            swiftSettings: .allUpcomingFeatures
        )
    }
}

extension Target.Tests.Adapter {
    static var driven: Target {
        .testTarget(
            name: "DrivenAdapterTests",
            dependencies: [.Adapter.driven],
            path: "Tests/Adapter/Driven",
            swiftSettings: .allUpcomingFeatures
        )
    }
}

// MARK: - External Library
extension Package.Dependency {
    static var swiftDependencies: Package.Dependency {
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            from: "1.10.1"
        )
    }

    static var swiftOpenAPIGenerator: Package.Dependency {
        .package(
            url: "https://github.com/apple/swift-openapi-generator",
            from: "1.10.4"
        )
    }

    static var swiftOpenAPIRuntime: Package.Dependency {
        .package(
            url: "https://github.com/apple/swift-openapi-runtime",
            from: "1.9.0"
        )
    }

    static var swiftOpenAPIURLSession: Package.Dependency {
        .package(
            url: "https://github.com/apple/swift-openapi-urlsession",
            from: "1.2.0"
        )
    }
}

extension Target.Dependency.ExternalLibrary {
    static var dependencies: Target.Dependency {
        .product(name: "Dependencies", package: "swift-dependencies")
    }

    static var dependenciesMacros: Target.Dependency {
        .product(name: "DependenciesMacros", package: "swift-dependencies")
    }

    static var openAPIRuntime: Target.Dependency {
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime")
    }

    static var openAPIURLSession: Target.Dependency {
        .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
    }
}

extension Target.PluginUsage.ExternalLibrary {
    static var openAPIGenerator: Target.PluginUsage {
        .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
    }
}

// MARK: - Swift Settings
// ref: https://github.com/treastrain/swift-upcomingfeatureflags-cheatsheet
extension SwiftSetting {
    static let existentialAny: Self = .enableUpcomingFeature("ExistentialAny")                                    // SE-0335, Swift 5.6,  SwiftPM 5.8+
    static let internalImportsByDefault: Self = .enableUpcomingFeature("InternalImportsByDefault")                // SE-0409, Swift 6.0,  SwiftPM 6.0+
    static let memberImportVisibility: Self = .enableUpcomingFeature("MemberImportVisibility")                    // SE-0444, Swift 6.1,  SwiftPM 6.1+
    static let inferIsolatedConformances: Self = .enableUpcomingFeature("InferIsolatedConformances")              // SE-0470, Swift 6.2,  SwiftPM 6.2+
    static let nonisolatedNonsendingByDefault: Self = .enableUpcomingFeature("NonisolatedNonsendingByDefault")    // SE-0461, Swift 6.2,  SwiftPM 6.2+
    static let immutableWeakCaptures: Self = .enableUpcomingFeature("ImmutableWeakCaptures")                      // SE-0481, Swift 6.2,  SwiftPM 6.2+

    static let allUpcomingFeatures: [Self] = [
        .existentialAny,
        .internalImportsByDefault,
        .memberImportVisibility,
        .inferIsolatedConformances,
        .nonisolatedNonsendingByDefault,
        .immutableWeakCaptures,
    ]
}

extension Array where Element == SwiftSetting {
    static let allUpcomingFeatures: Self = Element.allUpcomingFeatures
    static let forFeatureTarget: Self = .allUpcomingFeatures + [
        .defaultIsolation(MainActor.self)
    ]
}
