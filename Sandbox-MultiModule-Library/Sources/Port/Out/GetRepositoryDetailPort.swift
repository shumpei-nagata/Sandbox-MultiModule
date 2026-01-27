//
//  GetRepositoryDetailPort.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import DependenciesMacros
package import Domain

@DependencyClient
package struct GetRepositoryDetailPort: Sendable {
    // NOTE: https://github.com/pointfreeco/swift-composable-architecture/discussions/3769
    package var get: @concurrent @Sendable (_ owner: String, _ repo: String) async throws -> RepositoryDetail
}

// MARK: - TestDependencyKey
extension GetRepositoryDetailPort: TestDependencyKey {
    package static let testValue = Self()
}

// MARK: - DependencyValues
package extension DependencyValues {
    var getRepositoryDetailPort: GetRepositoryDetailPort {
        get { self[GetRepositoryDetailPort.self] }
        set { self[GetRepositoryDetailPort.self] = newValue }
    }
}
