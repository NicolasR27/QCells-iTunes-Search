//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by Qcells.
//  Copyright © 2025 QCells. All rights reserved.
//

public enum Module: Hashable {
    case app
    case presentation
    case domain
    case data
    case util
    
    public var name: String {
        switch self {
        case .app: ProjectInfo.appName
        default: "\(self)".capitalized
        }
    }
}

public enum ExternalModule: Sendable {
    case composableArchitecture
    case dependencies
    
    public var name: String {
        "\(self)".capitalized
    }
}

private extension String {
    var capitalized: String {
        guard let first else { return self }
        return String(first).uppercased() + dropFirst()
    }
}
