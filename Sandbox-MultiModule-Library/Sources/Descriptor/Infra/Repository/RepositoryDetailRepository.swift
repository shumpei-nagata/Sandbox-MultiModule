//
//  RepositoryDetailRepository.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DependenciesMacros
public import Model

@DependencyClient
public struct RepositoryDetailRepository: Sendable {
    public var get: @Sendable (_ owner: String, _ repo: String) async throws -> RepositoryDetail
}

// MARK: - TestDependencyKey
extension RepositoryDetailRepository: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    public var repositoryDetailRepository: RepositoryDetailRepository {
        get { self[RepositoryDetailRepository.self] }
        set { self[RepositoryDetailRepository.self] = newValue }
    }
}
