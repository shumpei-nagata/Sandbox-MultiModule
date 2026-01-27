//
//  SearchRepositoryPort.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import DependenciesMacros
package import Domain

@DependencyClient
package struct SearchRepositoryPort: Sendable {
    // NOTE: https://github.com/pointfreeco/swift-composable-architecture/discussions/3769
    package var search: @concurrent @Sendable (_ query: String) async throws -> [SearchResultItem]
}

// MARK: - TestDependencyKey
extension SearchRepositoryPort: TestDependencyKey {
    package static let testValue = Self()
}

// MARK: - DependencyValues
package extension DependencyValues {
    var searchRepositoryPort: SearchRepositoryPort {
        get { self[SearchRepositoryPort.self] }
        set { self[SearchRepositoryPort.self] = newValue }
    }
}
