//
//  GitHubAPI.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/22.
//

import Dependencies
import OpenAPIURLSession

extension Client: DependencyKey {
    package static let liveValue = try! Self( // swiftlint:disable:this force_try
        serverURL: Servers.Server1.url(),
        transport: URLSessionTransport()
    )
}

package extension DependencyValues {
    var gitHubAPI: Client {
        get { self[Client.self] }
        set { self[Client.self] = newValue }
    }
}
