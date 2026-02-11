//
//  Target.swift
//  ProjectDescriptionHelpers
//
//  Created by Qcells.
//  Copyright © 2025 QCells. All rights reserved.
//

import ProjectDescription

public extension Target {
    static func implements(_ module: Module) -> Target {
        return .target(
            name: module.name,
            destinations: ProjectInfo.destinations,
            product: module.product,
            bundleId: module.bundleID,
            deploymentTargets: ProjectInfo.deploymentTargets,
            infoPlist: module.infoPlist,
            sources: .default,
            resources: module.resources,
            dependencies: module.dependencies
        )
    }
}

private extension Module {
    var bundleID: String {
        let organizationName = ProjectInfo.organizationName.lowercased()
        let appName = ProjectInfo.appName.lowercased()
        let moduleName = name.lowercased()
        
        return switch self {
        case .app: "com.\(organizationName).\(appName)"
        default: "com.\(organizationName).\(appName).\(moduleName)"
        }
    }
    
    var product: Product {
        switch self {
        case .app: .app
        default: .staticLibrary
        }
    }
    
    var infoPlist: InfoPlist? {
        switch self {
        case .app: .base
        default: .default
        }
    }
    
    var resources: ResourceFileElements? {
        switch self {
        case .app, .presentation: .default
        default: nil
        }
    }
}

private extension InfoPlist {
    static let base: Self = .file(path: "Support/info.plist")
}

private extension SourceFilesList {
    static let `default`: Self = ["Sources/**"]
}

private extension ResourceFileElements {
    static let `default`: Self = ["Resources/**"]
}
