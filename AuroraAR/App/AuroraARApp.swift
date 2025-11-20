//
//  AuroraARApp.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-07.
//

import SwiftUI

@main
struct AuroraARApp: App {
    
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
