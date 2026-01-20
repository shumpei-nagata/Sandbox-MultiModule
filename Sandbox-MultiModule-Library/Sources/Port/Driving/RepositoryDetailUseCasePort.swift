//
//  RepositoryDetailUseCasePort.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DependenciesMacros
public import Domain

@DependencyClient
public struct RepositoryDetailUseCase: Sendable {
    // NOTE: https://github.com/pointfreeco/swift-composable-architecture/discussions/3769
    public var execute: @concurrent @Sendable (_ owner: String, _ repo: String) async throws -> RepositoryDetail
}

// MARK: - TestDependencyKey
extension RepositoryDetailUseCase: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    public var repositoryDetailUseCase: RepositoryDetailUseCase {
        get { self[RepositoryDetailUseCase.self] }
        set { self[RepositoryDetailUseCase.self] = newValue }
    }
}
