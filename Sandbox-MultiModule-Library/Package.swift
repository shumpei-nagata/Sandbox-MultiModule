// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sandbox-MultiModule-Library",
    platforms: [.iOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Sandbox-MultiModule-Library",
            targets: ["Sandbox-MultiModule-Library"]
        ),
    ],
    dependencies: [
        .swiftDependencies
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Sandbox-MultiModule-Library"
        ),
        .testTarget(
            name: "Sandbox-MultiModule-LibraryTests",
            dependencies: ["Sandbox-MultiModule-Library"]
        ),
    ]
)

extension Target {
    static var model: Target {
        .target(name: "Model")
    }
    
    static var domain: Target {
        .target(
            name: "Domain",
            dependencies: [
                .model,
                .repositoryInterface,
                .ExternalLibraries.swiftDependencies
            ]
        )
    }
    
    static var repositoryInterface: Target {
        .target(
            name: "RepositoryInterface",
            dependencies: [.model]
        )
    }
    
    static var infra: Target{
        .target(
            name: "Infra",
            dependencies: [
                .model,
                .repositoryInterface,
                .ExternalLibraries.swiftDependencies
            ]
        )
    }
    
    static var designSystem: Target {
        .target(name: "DesignSystem")
    }
}

extension Target.Dependency {
    static var model: Self {
        .target(name: Target.model.name)
    }
    
    static var domain: Self {
        .target(name: Target.domain.name)
    }
    
    static var designSystem: Self {
        .target(name: Target.designSystem.name)
    }
    
    static var repositoryInterface: Self {
        .target(name: Target.repositoryInterface.name)
    }
}

// MARK: - Features
extension Target {
    static var featureDescriptor: Target {
        .target(name: "FeatureDescriptor", dependencies: [.model])
    }
    
    enum Features {
        static var search: Target {
            .target(
                name: "SearchRepository",
                dependencies: [
                    .domain,
                    .designSystem,
                    .model,
                    .featureDescriptor
                ]
            )
        }
        
        static var repositoryDetail: Target {
            .target(
                name: "RepositoryDetail",
                dependencies: [
                    .domain,
                    .designSystem,
                    .model,
                    .featureDescriptor
                ]
            )
        }
    }
}

extension Target.Dependency {
    static var featureDescriptor: Self {
        .target(name: Target.featureDescriptor.name)
    }
}

// MARK: - External Libraries
extension Package.Dependency {
    static var swiftDependencies: Package.Dependency {
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            exact: "1.10.1"
        )
    }
}

extension Target.Dependency {
    enum ExternalLibraries {
        static var swiftDependencies: Target.Dependency {
            .product(name: "Dependencies", package: "swift-dependencies")
        }
    }
}
