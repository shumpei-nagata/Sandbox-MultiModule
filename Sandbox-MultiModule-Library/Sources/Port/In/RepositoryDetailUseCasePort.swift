//
//  RepositoryDetailUseCasePort.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import DependenciesMacros
package import Domain

@DependencyClient
package struct RepositoryDetailUseCase: Sendable {
    // NOTE: https://github.com/pointfreeco/swift-composable-architecture/discussions/3769
    package var execute: @concurrent @Sendable (_ owner: String, _ repo: String) async throws -> RepositoryDetail
}

// MARK: - TestDependencyKey
extension RepositoryDetailUseCase: TestDependencyKey {
    package static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    package var repositoryDetailUseCase: RepositoryDetailUseCase {
        get { self[RepositoryDetailUseCase.self] }
        set { self[RepositoryDetailUseCase.self] = newValue }
    }
}
