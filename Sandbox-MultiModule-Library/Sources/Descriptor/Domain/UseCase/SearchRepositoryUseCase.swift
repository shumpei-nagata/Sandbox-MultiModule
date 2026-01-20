//
//  SearchRepositoryUseCase.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
import DependenciesMacros
import Model

@DependencyClient
public struct SearchRepositoryUseCase: Sendable {
    public var execute: @Sendable (_ query: String) async throws -> [SearchResultItem]
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
