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
                Target.Core.domain.name,
                Target.Core.infra.name,
                Target.Feature.searchRepository.name,
                Target.Feature.repositoryDetail.name,
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
        .Core.designSystem,
        .Core.domain,
        .Core.infra,
        .Core.model,
        .Descriptor.domain,
        .Descriptor.feature,
        .Descriptor.infra,
        .Feature.searchRepository,
        .Feature.repositoryDetail,
        .Tests.Core.domain,
        .Tests.Core.infra
    ]
)

extension Target {
    enum Core {}
    enum Descriptor {}
    enum Feature {}

    enum Tests {
        enum Core {}
    }
}

extension Target.Dependency {
    enum Core {}
    enum Descriptor {}
    enum ExternalLibrary {}
}

extension Target.PluginUsage {
    enum ExternalLibrary {}
}

// MARK: - Core
extension Target.Core {
    static var designSystem: Target {
        .target(
            name: "DesignSystem",
            path: "Sources/Core/DesignSystem",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var domain: Target {
        .target(
            name: "Domain",
            dependencies: [
                .Core.model,
                .Descriptor.domain,
                .Descriptor.infra,
                .ExternalLibrary.dependencies
            ],
            path: "Sources/Core/Domain",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var infra: Target {
        .target(
            name: "Infra",
            dependencies: [
                .Core.model,
                .Descriptor.infra,
                .ExternalLibrary.dependencies,
                .ExternalLibrary.openAPIRuntime,
                .ExternalLibrary.openAPIURLSession
            ],
            path: "Sources/Core/Infra",
            swiftSettings: .allUpcomingFeatures,
            plugins: [
                .ExternalLibrary.openAPIGenerator
            ]
        )
    }

    static var model: Target {
        .target(
            name: "Model",
            path: "Sources/Core/Model",
            swiftSettings: .allUpcomingFeatures
        )
    }
}

extension Target.Dependency.Core {
    static var designSystem: Target.Dependency {
        .target(name: Target.Core.designSystem.name)
    }

    static var domain: Target.Dependency {
        .target(name: Target.Core.domain.name)
    }

    static var infra: Target.Dependency {
        .target(name: Target.Core.infra.name)
    }

    static var model: Target.Dependency {
        .target(name: Target.Core.model.name)
    }
}

// MARK: - Descriptor
extension Target.Descriptor {
    static var domain: Target {
        .target(
            name: "DomainDescriptor",
            dependencies: [
                .Core.model,
                .ExternalLibrary.dependencies,
                .ExternalLibrary.dependenciesMacros
            ],
            path: "Sources/Descriptor/Domain",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var feature: Target {
        .target(
            name: "FeatureDescriptor",
            dependencies: [
                .Core.model,
                .ExternalLibrary.dependencies,
                .ExternalLibrary.dependenciesMacros
            ],
            path: "Sources/Descriptor/Feature",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var infra: Target {
        .target(
            name: "InfraDescriptor",
            dependencies: [
                .Core.model,
                .ExternalLibrary.dependencies,
                .ExternalLibrary.dependenciesMacros
            ],
            path: "Sources/Descriptor/Infra",
            swiftSettings: .allUpcomingFeatures
        )
    }
}

extension Target.Dependency.Descriptor {
    static var domain: Target.Dependency {
        .target(name: Target.Descriptor.domain.name)
    }

    static var feature: Target.Dependency {
        .target(name: Target.Descriptor.feature.name)
    }

    static var infra: Target.Dependency {
        .target(name: Target.Descriptor.infra.name)
    }
}

// MARK: - Feature
extension Target.Feature {
    static var searchRepository: Target {
        .target(
            name: "SearchRepository",
            dependencies: [
                .Core.designSystem,
                .Core.model,
                .Descriptor.domain,
                .Descriptor.feature,
                .ExternalLibrary.dependencies
            ],
            path: "Sources/Feature/SearchRepository",
            swiftSettings: .forFeatureTarget
        )
    }

    static var repositoryDetail: Target {
        .target(
            name: "RepositoryDetail",
            dependencies: [
                .Core.designSystem,
                .Core.model,
                .Descriptor.domain,
                .Descriptor.feature,
                .ExternalLibrary.dependencies
            ],
            path: "Sources/Feature/RepositoryDetail",
            swiftSettings: .forFeatureTarget
        )
    }
}

// MARK: - Tests
extension Target.Tests.Core {
    static var domain: Target {
        .testTarget(
            name: "DomainTests",
            dependencies: [.Core.domain],
            path: "Tests/Core/Domain",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var infra: Target {
        .testTarget(
            name: "InfraTests",
            dependencies: [.Core.infra],
            path: "Tests/Core/Infra",
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
