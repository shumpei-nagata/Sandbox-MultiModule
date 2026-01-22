//
//  RepositoryDetailUseCase.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Dependencies
package import InPort
import OutPort

// MARK: - DependencyKey
extension RepositoryDetailUseCase: DependencyKey {
    package static let liveValue = Self(
        execute: { owner, repo in
            @Dependency(\.getRepositoryDetailPort) var port
            return try await port.get(owner: owner, repo: repo)
        }
    )
}
