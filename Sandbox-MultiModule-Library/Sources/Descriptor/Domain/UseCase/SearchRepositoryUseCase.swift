//
//  SearchRepositoryUseCase.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DependenciesMacros
public import Model

@DependencyClient
public struct SearchRepositoryUseCase: Sendable {
    // NOTE: https://github.com/pointfreeco/swift-composable-architecture/discussions/3769
    public var execute: @concurrent @Sendable (_ query: String) async throws -> [SearchResultItem]
}

// MARK: - TestDependencyKey
extension SearchRepositoryUseCase: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    public var searchRepositoryUseCase: SearchRepositoryUseCase {
        get { self[SearchRepositoryUseCase.self] }
        set { self[SearchRepositoryUseCase.self] = newValue }
    }
}
