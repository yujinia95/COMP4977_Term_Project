//
//  CameraColorPickerViewModel.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
import Foundation
import AVFoundation
import UIKit
import Combine

// ViewModel that:
// - Manages the camera capture session
// - Keeps the latest camera frame
// - When user taps, analyzes a small area and finds the top 3 colors
final class CameraColorPickerViewModel: NSObject, ObservableObject {

    // List of colors detected from tap (up to 3)
    @Published var colors: [DetectedColor] = []

    // The main camera capture session (controls camera input + output).
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let processingQueue = DispatchQueue(label: "CameraColorPicker.Queue")
    private var latestBuffer: CMSampleBuffer?

    override init() {
        super.init()
        configureSession()
    }

    // Starts the camera session.
    func startSession() {
        processingQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    // Stops the camera session.
    func stopSession() {
        processingQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    // Configures the AVCaptureSession:
    // - Chooses the back camera
    // - Adds camera input
    // - Sets up video output with BGRA pixels
    // - Assigns self as the frame delegate
    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("Unable to create camera input")
            session.commitConfiguration()
            return
        }
        session.addInput(input)

        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: processingQueue)

        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        } else {
            print("Cannot add video output")
        }

        session.commitConfiguration()
    }

    // Called when the user taps on the screen.
    //
    // Steps:
    // - Use the latest camera frame
    // - Convert tap location into pixel coordinates in the image
    // - Sample a square region around that point
    // - Group similar colors into "buckets"
    // - Pick the top 3 most common buckets
    // - Convert them into UIColor, hex string, and a simple name
    func captureColors(at normalizedPoint: CGPoint) {
        guard let buffer = latestBuffer,
              let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            print("No frame yet")
            return
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let bytesPerPixel = 4

        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else { return }

        let xCenter = Int(normalizedPoint.x * CGFloat(width))
        let yCenter = Int((1.0 - normalizedPoint.y) * CGFloat(height))

        let radius = 20
        let xMin = max(0, xCenter - radius)
        let xMax = min(width - 1, xCenter + radius)
        let yMin = max(0, yCenter - radius)
        let yMax = min(height - 1, yCenter + radius)

        var buckets: [Int: Int] = [:]

        for y in yMin...yMax {
            let rowPtr = baseAddress.advanced(by: y * bytesPerRow)
            for x in xMin...xMax {
                let pixelPtr = rowPtr.advanced(by: x * bytesPerPixel)

                let b = pixelPtr.load(fromByteOffset: 0, as: UInt8.self)
                let g = pixelPtr.load(fromByteOffset: 1, as: UInt8.self)
                let r = pixelPtr.load(fromByteOffset: 2, as: UInt8.self)

                let rq = Int(r) / 32
                let gq = Int(g) / 32
                let bq = Int(b) / 32

                let key = (rq << 16) | (gq << 8) | bq
                buckets[key, default: 0] += 1
            }
        }

        let top = buckets.sorted { $0.value > $1.value }.prefix(3)

        var result: [DetectedColor] = []

        for (key, _) in top {
            let rq = (key >> 16) & 0xFF
            let gq = (key >> 8) & 0xFF
            let bq = key & 0xFF

            let r = CGFloat(rq * 32 + 16) / 255.0
            let g = CGFloat(gq * 32 + 16) / 255.0
            let b = CGFloat(bq * 32 + 16) / 255.0

            let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
            let hex = Self.hexString(from: color)
            let name = Self.simpleName(for: color)

            result.append(DetectedColor(uiColor: color, hex: hex, name: name))
        }

        DispatchQueue.main.async {
            self.colors = result
        }
    }

    // Converts a UIColor into a hex string like "#RRGGBB".
    private static func hexString(from color: UIColor) -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255),
                      Int(g * 255), Int(b * 255))
    }

    // Gives a simple human-readable name based on the color’s
    // - Black / White / Gray based on brightness & saturation
    // - Otherwise, chooses a color name based on hue angle
    private static func simpleName(for color: UIColor) -> String {
        var h: CGFloat = 0, s: CGFloat = 0, v: CGFloat = 0, a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &v, alpha: &a)

        if v < 0.15 { return "Black" }
        if v > 0.92 && s < 0.15 { return "White" }
        if s < 0.2 { return "Gray" }

        let deg = h * 360
        switch deg {
        case 0..<15, 345...360: return "Red"
        case 15..<45: return "Orange"
        case 45..<65: return "Yellow"
        case 65..<170: return "Green"
        case 170..<200: return "Cyan"
        case 200..<250: return "Blue"
        case 250..<290: return "Purple"
        case 290..<330: return "Magenta"
        default: return "Color"
        }
    }
}

extension CameraColorPickerViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // This is called every time the camera provides a new frame.
    // Just store the latest frame and use it later when the user taps on the screen.
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        // Store latest frame so `captureColors` can read it
        latestBuffer = sampleBuffer
    }
}


