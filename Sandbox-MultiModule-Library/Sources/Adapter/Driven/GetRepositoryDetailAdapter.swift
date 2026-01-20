//
//  GetRepositoryDetailAdapter.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Dependencies
import Domain
public import DrivenPort
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - DependencyKey
extension GetRepositoryDetailPort: DependencyKey {
    public static let liveValue = Self(
        get: { owner, repo in
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let response = try await client
                .reposGet(path: .init(owner: owner, repo: repo))
                .ok
                .body
                .json

            guard
                let htmlUrl = URL(string: response.htmlUrl),
                let cloneUrl = URL(string: response.cloneUrl),
                let avatarUrl = URL(string: response.owner.avatarUrl)
            else {
                throw URLError(.badURL)
            }

            return RepositoryDetail(
                id: response.id,
                name: response.name,
                fullName: response.fullName,
                owner: .init(
                    id: Int(response.owner.id),
                    login: response.owner.login,
                    avatarUrl: avatarUrl
                ),
                description: response.description,
                htmlUrl: htmlUrl,
                cloneUrl: cloneUrl,
                sshUrl: response.sshUrl,
                language: response.language,
                stargazersCount: response.stargazersCount,
                watchersCount: response.watchersCount,
                forksCount: response.forksCount,
                openIssuesCount: response.openIssuesCount,
                size: response.size,
                defaultBranch: response.defaultBranch,
                topics: response.topics ?? [],
                visibility: response.visibility,
                hasIssues: response.hasIssues,
                hasProjects: response.hasProjects,
                hasWiki: response.hasWiki,
                hasPages: response.hasPages,
                hasDiscussions: response.hasDiscussions,
                archived: response.archived,
                disabled: response.disabled,
                isTemplate: response.isTemplate ?? false,
                createdAt: response.createdAt,
                updatedAt: response.updatedAt,
                pushedAt: response.pushedAt
            )
        }
    )
}
