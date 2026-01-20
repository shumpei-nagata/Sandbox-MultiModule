//
//  RepositoryDetailUseCase.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DependenciesMacros
public import Model

@DependencyClient
public struct RepositoryDetailUseCase: Sendable {
    public var execute: @Sendable (_ owner: String, _ repo: String) async throws -> RepositoryDetail
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
