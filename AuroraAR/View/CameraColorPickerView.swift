//
//  CameraColorPickerView.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
// This is the view that allows the user to point their camera at something and tap to detect colours.

import SwiftUI
import AVFoundation

struct CameraColorPickerView: View {
    @StateObject private var viewModel = CameraColorPickerViewModel() // Manages camera and color detection logic
    @Environment(\.dismiss) private var dismiss // dismiss is a function to close THIS screen and go back
    
    // This Zstack contains the Camera, touch detection, back button
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ZStack {
                    CameraPreview(session: viewModel.session)
                        .ignoresSafeArea()

                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    let location = value.location
                                    let normX = location.x / geo.size.width
                                    let normY = location.y / geo.size.height
                                    viewModel.captureColors(at: CGPoint(x: normX, y: normY))
                                }
                        )
                }
            }

            VStack {
                // (removed custom Back button — use system back button)

                Spacer()

                // Bottom sheet with colours
                VStack(spacing: 8) {
                    Text("Tap anywhere to detect colours")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if !viewModel.colors.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.colors) { color in
                                    VStack(spacing: 6) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(color.uiColor))
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(.white.opacity(0.4), lineWidth: 1)
                                            )

                                        Text(color.name)
                                            .font(.caption2)
                                            .foregroundStyle(.white)
                                            .lineLimit(1)

                                        Text(color.hex)
                                            .font(.caption2)
                                            .foregroundStyle(.white.opacity(0.9))
                                            .lineLimit(1)

                                        Button {
                                        } label: {
                                            Text("Save")
                                                .font(.caption2.bold())
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 4)
                                                .background(.white.opacity(0.15))
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .onAppear { viewModel.startSession() }
        .onDisappear { viewModel.stopSession() }
    }
}

#Preview {
    NavigationStack {
        CameraColorPickerView()
    }
}

