//
//  Sandbox_MultiModule_iOSApp.swift
//  Sandbox-MultiModule-iOSApp
//
//  Created by Shumpei Nagata on 2026/01/19.
//

import Dependencies
import FeatureDescriptor
import SwiftUI

@main
struct Sandbox_MultiModule_iOSApp: App {
    @Dependency(\.searchRepositoryViewBuilder.build) private var searchRepositoryView

    var body: some Scene {
        WindowGroup {
            searchRepositoryView()
        }
    }
}
