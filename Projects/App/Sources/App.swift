//
//  App.swift
//  QCells
//
//  Created by QCells.
//  Copyright © 2025 QCells. All rights reserved.
//

import ComposableArchitecture
import Data
import Presentation
import SwiftUI

@main
struct QCellsApp: App {
    let store = Store(initialState: MainFeature.State()) {
        MainFeature()
    } withDependencies: {
        $0.iTunesSearchClient = .live
    }

    var body: some Scene {
        WindowGroup {
            MainView(store: store)
        }
    }
}
