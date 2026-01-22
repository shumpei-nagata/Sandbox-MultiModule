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
                Target.useCase.name,
                Target.Adapter.out.name,
                Target.Feature.repositoryDetail.name,
                Target.Feature.searchRepository.name
            ]
        ),
        .forDev(.useCase),
        .forDev(.Adapter.out),
        .forDev(.Feature.repositoryDetail),
        .forDev(.Feature.searchRepository)
    ],
    dependencies: [
        .swiftDependencies,
        .swiftOpenAPIGenerator,
        .swiftOpenAPIRuntime,
        .swiftOpenAPIURLSession
    ],
    targets: .allTargets
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

extension Array where Element == Target {
    static var allTargets: Self {
        [
            .designSystem,
            .domain,
            .featureBuilder,
            .useCase
        ]
        + Self.adapters
        + Self.features
        + Self.infras
        + Self.ports
        + Self.tests
    }
}

extension Product {
    static func forDev(_ target: Target) -> Product {
        .library(
            name: target.name,
            targets: [target.name]
        )
    }
}

// MARK: - Targets
extension Target {
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

    static var useCase: Target {
        .target(
            name: "UseCase",
            dependencies: [
                .domain,
                .ExternalLibrary.dependencies,
                .Port.in,
                .Port.out
            ],
            path: "Sources/UseCase",
            swiftSettings: .allUpcomingFeatures
        )
    }
}

extension Target.Dependency {
    static var designSystem: Target.Dependency {
        .target(name: Target.designSystem.name)
    }

    static var domain: Target.Dependency {
        .target(name: Target.domain.name)
    }

    static var featureBuilder: Target.Dependency {
        .target(name: Target.featureBuilder.name)
    }

    static var useCase: Target.Dependency {
        .target(name: Target.useCase.name)
    }
}

// MARK: - Adapter
extension Array where Element == Target {
    static var adapters: Self {
        [.Adapter.out]
    }
}

extension Target.Adapter {
    static var out: Target {
        .target(
            name: "OutAdapter",
            dependencies: [
                .domain,
                .ExternalLibrary.dependencies,
                .Infra.gitHubAPI,
                .Port.out
            ],
            path: "Sources/Adapter/Out",
            swiftSettings: .allUpcomingFeatures
        )
    }
}

extension Target.Dependency.Adapter {
    static var out: Target.Dependency {
        .target(name: Target.Adapter.out.name)
    }
}

// MARK: - Feature
extension Array where Element == Target {
    static var features: Self {
        [
            .Feature.repositoryDetail,
            .Feature.searchRepository
        ]
    }
}

extension Target.Feature {
    static var repositoryDetail: Target {
        .target(
            name: "RepositoryDetailFeature",
            dependencies: [
                .designSystem,
                .domain,
                .featureBuilder,
                .ExternalLibrary.dependencies,
                .Port.in
            ],
            path: "Sources/Feature/RepositoryDetail",
            swiftSettings: .forFeatureTarget
        )
    }

    static var searchRepository: Target {
        .target(
            name: "SearchRepositoryFeature",
            dependencies: [
                .designSystem,
                .domain,
                .featureBuilder,
                .ExternalLibrary.dependencies,
                .Port.in
            ],
            path: "Sources/Feature/SearchRepository",
            swiftSettings: .forFeatureTarget
        )
    }
}

// MARK: - Infra
extension Array where Element == Target {
    static var infras: Self {
        [.Infra.gitHubAPI]
    }
}

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
extension Array where Element == Target {
    static var ports: Self {
        [
            .Port.in,
            .Port.out
        ]
    }
}

extension Target.Port {
    static var `in`: Target {
        .target(
            name: "InPort",
            dependencies: [
                .domain,
                .ExternalLibrary.dependencies,
                .ExternalLibrary.dependenciesMacros
            ],
            path: "Sources/Port/In",
            swiftSettings: .allUpcomingFeatures
        )
    }

    static var out: Target {
        .target(
            name: "OutPort",
            dependencies: [
                .domain,
                .ExternalLibrary.dependencies,
                .ExternalLibrary.dependenciesMacros
            ],
            path: "Sources/Port/Out",
            swiftSettings: .allUpcomingFeatures
        )
    }

}

extension Target.Dependency.Port {
    static var `in`: Target.Dependency {
        .target(name: Target.Port.in.name)
    }

    static var out: Target.Dependency {
        .target(name: Target.Port.out.name)
    }
}

// MARK: - Tests
extension Array where Element == Target {
    static var tests: [Target] {
        [
            .Tests.useCase,
            .Tests.Adapter.out
        ]
    }
}

extension Target.Tests {
    static var useCase: Target {
        .testTarget(
            name: "UseCaseTests",
            dependencies: [.useCase],
            path: "Tests/UseCase",
            swiftSettings: .allUpcomingFeatures
        )
    }
}

extension Target.Tests.Adapter {
    static var out: Target {
        .testTarget(
            name: "OutAdapterTests",
            dependencies: [.Adapter.out],
            path: "Tests/Adapter/Out",
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
