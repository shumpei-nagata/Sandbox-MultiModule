//
//  GetRepositoryDetailPort.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import DependenciesMacros
public import Domain

@DependencyClient
public struct GetRepositoryDetailPort: Sendable {
    // NOTE: https://github.com/pointfreeco/swift-composable-architecture/discussions/3769
    public var get: @concurrent @Sendable (_ owner: String, _ repo: String) async throws -> RepositoryDetail
}

// MARK: - TestDependencyKey
extension GetRepositoryDetailPort: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues
extension DependencyValues {
    public var getRepositoryDetailPort: GetRepositoryDetailPort {
        get { self[GetRepositoryDetailPort.self] }
        set { self[GetRepositoryDetailPort.self] = newValue }
    }
}
