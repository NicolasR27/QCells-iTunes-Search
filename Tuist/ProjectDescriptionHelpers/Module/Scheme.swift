//
//  Scheme.swift
//  ProjectDescriptionHelpers
//
//  Created by Qcells.
//  Copyright © 2025 QCells. All rights reserved.
//

import ProjectDescription

public extension Scheme {
    static var app: Scheme {
        let name = Module.app.name
        return .scheme(
            name: name,
            buildAction: .buildAction(targets: [.target(name)]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    }
}
