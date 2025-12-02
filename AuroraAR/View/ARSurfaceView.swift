//
//  ARSurfaceView.swift
//  AuroraAR
//
//  Created by Amal Allaham on 2025-12-02.
//

import SwiftUI

struct ARSurfaceView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var colorsVM = SavedColorsViewModel()

    var body: some View {
        ZStack {
            if colorsVM.isLoading {
                ProgressView("Loading your saved colors...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let error = colorsVM.errorMessage {
                VStack(spacing: 16) {
                    Text("Failed to load colors")
                        .font(.headline)
                    Text(error)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)

                    Button("Retry") {
                        Task {
                            if let token = appState.authToken {
                                await colorsVM.fetchSavedColors()
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else if !colorsVM.savedColors.isEmpty {
                SurfaceARViewRepresentable(colors: colorsVM.uiColors)
                    .ignoresSafeArea()
            } else {
                VStack(spacing: 16) {
                    Text("No saved colors yet")
                        .font(.headline)
                    Text("Add some colors in your app, then come back here.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
        .task {
                await colorsVM.fetchSavedColors()
        }
    }
}
