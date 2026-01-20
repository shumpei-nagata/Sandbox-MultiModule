//
//  SearchResultItem.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

public import Foundation

public struct SearchResultItem: Sendable, Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let fullName: String
    public let owner: Owner?
    public let description: String?
    public let htmlUrl: URL
    public let language: String?
    public let stargazersCount: Int
    public let watchersCount: Int
    public let forksCount: Int
    public let openIssuesCount: Int
    public let defaultBranch: String
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: Int,
        name: String,
        fullName: String,
        owner: Owner?,
        description: String?,
        htmlUrl: URL,
        language: String?,
        stargazersCount: Int,
        watchersCount: Int,
        forksCount: Int,
        openIssuesCount: Int,
        defaultBranch: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.owner = owner
        self.description = description
        self.htmlUrl = htmlUrl
        self.language = language
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
        self.forksCount = forksCount
        self.openIssuesCount = openIssuesCount
        self.defaultBranch = defaultBranch
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Owner
extension SearchResultItem {
    public struct Owner: Sendable, Hashable {
        public let id: Int
        public let login: String
        public let avatarUrl: URL

        public init(id: Int, login: String, avatarUrl: URL) {
            self.id = id
            self.login = login
            self.avatarUrl = avatarUrl
        }
    }
}
