//
//  RepositoryDetailUseCase.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
public import DrivingPort
import DrivenPort

// MARK: - DependencyKey
extension RepositoryDetailUseCase: DependencyKey {
    public static let liveValue = Self(
        execute: { owner, repo in
            @Dependency(\.getRepositoryDetailPort) var port
            return try await port.get(owner: owner, repo: repo)
        }
    )
}
