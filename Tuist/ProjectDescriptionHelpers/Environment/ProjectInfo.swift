//
//  ProjectInfo.swift
//  ProjectDescriptionHelpers
//
//  Created by Qcells.
//  Copyright © 2025 QCells. All rights reserved.
//

import ProjectDescription

public enum ProjectInfo {
    public static let organizationName: String = "QCells"
    public static let appName: String = "QCells"
    public static let destinations: Destinations = [.iPhone]
    public static let deploymentTargets: DeploymentTargets = .iOS("18.0")
}
