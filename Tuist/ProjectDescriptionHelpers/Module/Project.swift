//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Qcells.
//  Copyright © 2025 QCells. All rights reserved.
//

import ProjectDescription

public extension Project {
    init(module: Module) {
        self = Project(
            name: module.name,
            organizationName: ProjectInfo.organizationName,
            options: .options(automaticSchemesOptions: .disabled),
            targets: module.targets,
            schemes: module.schemes,
            resourceSynthesizers: module.resourceSynthesizers
        )
    }
}

private extension Module {
    var targets: [Target] {
        [.implements(self)]
    }
    
    var schemes: [Scheme] {
        switch self {
        case .app: [.app]
        default: []
        }
    }
    
    var resourceSynthesizers: [ResourceSynthesizer] {
        switch self {
        case .presentation: [.fonts(), .images, .colors]
        default: []
        }
    }
}

private extension ResourceSynthesizer {
    static let images: Self = .custom(name: "Images", parser: .assets, extensions: ["xcassets"])
    static let colors: Self = .custom(name: "Colors", parser: .assets, extensions: ["xcassets"])
}
