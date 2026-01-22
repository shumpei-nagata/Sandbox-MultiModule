//
//  GitHubAPI.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/22.
//

import Dependencies
import OpenAPIURLSession

extension Client: DependencyKey {
    package static let liveValue = try! Self(
        serverURL: Servers.Server1.url(),
        transport: URLSessionTransport()
    )
}

extension DependencyValues {
    package var gitHubAPI: Client {
        get { self[Client.self] }
        set { self[Client.self] = newValue }
    }
}
