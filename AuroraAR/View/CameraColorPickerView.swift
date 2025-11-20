//
//  CameraColorPickerView.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
import SwiftUI
import AVFoundation

struct CameraColorPickerView: View {
    @StateObject private var viewModel = CameraColorPickerViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GeometryReader { geo in
                ZStack {
                    CameraPreview(session: viewModel.session)
                        .ignoresSafeArea()

                    // Tap overlay
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
                // Top bar with back button
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.callout.weight(.semibold))
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    }

                    Spacer()
                }
                .padding([.top, .horizontal], 16)

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
                                            // TODO: future: save to backend
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

