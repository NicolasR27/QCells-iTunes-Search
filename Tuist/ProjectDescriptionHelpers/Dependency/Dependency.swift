//
//  Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by Qcells.
//  Copyright © 2025 QCells. All rights reserved.
//

import ProjectDescription

extension Module {
    private static var dependencyInfo: [Module: [Module]] {
        [
            .app: [.presentation, .data],
            .presentation: [.domain],
            .data: [.domain],
            .domain: [.util]
        ]
    }
    
    private static var externalDependencyInfo: [Module: [ExternalModule]] {
        [
            .presentation: [.composableArchitecture],
            .util: [.dependencies]
        ]
    }
    
    private var path: Path {
        .relativeToRoot("Projects/\(name)")
    }
    
    var dependencies: [TargetDependency] {
        var allDependencies: [TargetDependency] = []
        
        if let dependencies = Module.dependencyInfo[self] {
            allDependencies += dependencies.map { module in
                TargetDependency.project(target: module.name, path: module.path)
            }
        }
        
        if let externalDependencies = Module.externalDependencyInfo[self] {
            allDependencies += externalDependencies.map { module in
                TargetDependency.external(name: module.name)
            }
        }
        return allDependencies
    }
}
