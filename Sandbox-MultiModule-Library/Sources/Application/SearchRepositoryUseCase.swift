//
//  SearchRepositoryUseCase.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
public import DrivingPort
import DrivenPort

// MARK: - DependencyKey
extension SearchRepositoryUseCase: DependencyKey {
    public static let liveValue = Self(
        execute: { query in
            @Dependency(\.searchRepositoryPort) var port
            return try await port.search(query: query)
        }
    )
}
