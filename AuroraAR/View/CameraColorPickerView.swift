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
    @State private var touchLocation: CGPoint? = nil
    @State private var showTouchIndicator: Bool = false
    @State private var previewLayer: AVCaptureVideoPreviewLayer? = nil
    
    // This Zstack contains the Camera, touch detection, back button
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ZStack {
                    CameraPreview(session: viewModel.session) { layer in
                        previewLayer = layer
                    }
                    .ignoresSafeArea()

                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    let location = value.location

                                    // Store location for indicator (view coordinates)
                                    touchLocation = location
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                        showTouchIndicator = true
                                    }

                                    // Convert tap location to camera device coordinates using preview layer
                                    if let layer = previewLayer {
                                        let devicePoint = layer.captureDevicePointConverted(fromLayerPoint: location)
                                        viewModel.captureColors(at: devicePoint)
                                    } else {
                                        // Fallback (shouldn't happen)
                                        let normX = location.x / geo.size.width
                                        let normY = location.y / geo.size.height
                                        viewModel.captureColors(at: CGPoint(x: normX, y: normY))
                                    }

                                    // Hide the indicator after a short delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        withAnimation(.easeOut(duration: 0.25)) {
                                            showTouchIndicator = false
                                        }
                                    }
                                }
                        )

                    // Touch indicator square aligned to the tap location
                    // Matches the 41×41 pixel sampling area (radius 20 + center pixel)
                    if let loc = touchLocation {
                        let indicatorSize: CGFloat = {
                            if let layer = previewLayer {
                                return calculateIndicatorSize(for: layer)
                            }
                            return 60 // fallback size if layer not ready
                        }()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(.white.opacity(0.9), lineWidth: 2)
                            .background(RoundedRectangle(cornerRadius: 4).fill(.white.opacity(0.12)))
                            .frame(width: indicatorSize, height: indicatorSize)
                            .scaleEffect(showTouchIndicator ? 1.0 : 0.6)
                            .opacity(showTouchIndicator ? 1.0 : 0.0)
                            .position(x: loc.x, y: loc.y)
                            .allowsHitTesting(false)
                    }
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
                                            Task {
                                                await viewModel.saveColor(colorName: color.name, colorCode: color.hex)
                                            }
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
    
    // Calculate the screen size that corresponds to 41 pixels in the camera buffer
    // (the sampling area is 41×41: center ± 20 pixels)
    private func calculateIndicatorSize(for layer: AVCaptureVideoPreviewLayer) -> CGFloat {
        // Get the camera buffer dimensions from the session
        guard let input = viewModel.session.inputs.first as? AVCaptureDeviceInput else {
            return 50 // fallback size
        }
        
        let format = input.device.activeFormat
        let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
        let bufferWidth = CGFloat(dimensions.width)
        
        // Sampling radius is 20 pixels, so total sampling area is 41×41 pixels
        let samplingPixels: CGFloat = 41
        
        // Convert device coordinate span to layer coordinate span
        // Device coordinates are normalized (0-1), so the span in device space is:
        let deviceSpan = samplingPixels / bufferWidth
        
        // Convert a small rect in device coordinates to layer coordinates to find the size
        let centerDevice = CGPoint(x: 0.5, y: 0.5)
        let leftDevice = CGPoint(x: centerDevice.x - deviceSpan/2, y: centerDevice.y)
        let rightDevice = CGPoint(x: centerDevice.x + deviceSpan/2, y: centerDevice.y)
        
        let leftLayer = layer.layerPointConverted(fromCaptureDevicePoint: leftDevice)
        let rightLayer = layer.layerPointConverted(fromCaptureDevicePoint: rightDevice)
        
        let screenSize = abs(rightLayer.x - leftLayer.x)
        
        return max(screenSize, 20) // minimum 20pt for visibility
    }
}

#Preview {
    NavigationStack {
        CameraColorPickerView()
    }
}

