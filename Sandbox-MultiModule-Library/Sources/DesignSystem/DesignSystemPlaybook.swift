//
//  DesignSystemPlaybook.swift
//  Sandbox-MultiModule-Library
//
//  Created by Shumpei Nagata on 2026/01/27.
//

import Prefire
import SwiftUI

public struct DesignSystemPlaybook: View {
    public var body: some View {
        PlaybookView(
            isComponent: true,
            previewModels: PreviewModels.models
        )
    }

    public init() {}
}
