//
//  SearchRepositoryUseCasePort.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import DependenciesMacros
package import Domain

@DependencyClient
package struct SearchRepositoryUseCase: Sendable {
    // NOTE: https://github.com/pointfreeco/swift-composable-architecture/discussions/3769
    package var execute: @concurrent @Sendable (_ query: String) async throws -> [SearchResultItem]
}

// MARK: - TestDependencyKey
extension SearchRepositoryUseCase: TestDependencyKey {
    package static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    package var searchRepositoryUseCase: SearchRepositoryUseCase {
        get { self[SearchRepositoryUseCase.self] }
        set { self[SearchRepositoryUseCase.self] = newValue }
    }
}
