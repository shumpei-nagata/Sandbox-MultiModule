//
//  RepositoryDetail.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/20.
//

import Foundation

public struct RepositoryDetail: Sendable, Hashable, Identifiable {
    public let id: Int64
    public let name: String
    public let fullName: String
    public let owner: Owner
    public let description: String?
    public let htmlUrl: URL
    public let cloneUrl: URL
    public let sshUrl: String
    public let language: String?
    public let stargazersCount: Int
    public let watchersCount: Int
    public let forksCount: Int
    public let openIssuesCount: Int
    public let size: Int
    public let defaultBranch: String
    public let topics: [String]
    public let visibility: String?
    public let hasIssues: Bool
    public let hasProjects: Bool
    public let hasWiki: Bool
    public let hasPages: Bool
    public let hasDiscussions: Bool
    public let archived: Bool
    public let disabled: Bool
    public let isTemplate: Bool
    public let createdAt: Date
    public let updatedAt: Date
    public let pushedAt: Date

    public init(
        id: Int64,
        name: String,
        fullName: String,
        owner: Owner,
        description: String?,
        htmlUrl: URL,
        cloneUrl: URL,
        sshUrl: String,
        language: String?,
        stargazersCount: Int,
        watchersCount: Int,
        forksCount: Int,
        openIssuesCount: Int,
        size: Int,
        defaultBranch: String,
        topics: [String],
        visibility: String?,
        hasIssues: Bool,
        hasProjects: Bool,
        hasWiki: Bool,
        hasPages: Bool,
        hasDiscussions: Bool,
        archived: Bool,
        disabled: Bool,
        isTemplate: Bool,
        createdAt: Date,
        updatedAt: Date,
        pushedAt: Date
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.owner = owner
        self.description = description
        self.htmlUrl = htmlUrl
        self.cloneUrl = cloneUrl
        self.sshUrl = sshUrl
        self.language = language
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
        self.forksCount = forksCount
        self.openIssuesCount = openIssuesCount
        self.size = size
        self.defaultBranch = defaultBranch
        self.topics = topics
        self.visibility = visibility
        self.hasIssues = hasIssues
        self.hasProjects = hasProjects
        self.hasWiki = hasWiki
        self.hasPages = hasPages
        self.hasDiscussions = hasDiscussions
        self.archived = archived
        self.disabled = disabled
        self.isTemplate = isTemplate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pushedAt = pushedAt
    }
}

// MARK: - Owner
extension RepositoryDetail {
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
