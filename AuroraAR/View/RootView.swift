//
//  RootView.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            Group {
                if appState.isLoggedIn {
                    UserMenuView()
                } else {
                    LandingView()
                }
            }
        }
    }
}

