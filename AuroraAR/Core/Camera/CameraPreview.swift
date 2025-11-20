// Core/Camera/CameraPreview.swift
// This module creates a camera viewfinder (what you see when you open phone's camera app)
import SwiftUI
import AVFoundation


struct CameraPreview: UIViewRepresentable {
    // Create a camera session using AVCaptureSession
    let session: AVCaptureSession

    // Creates a container view for displaying the camera
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
    
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    // This runs once when SwiftUI first creates the view
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill // fill the entire screen, crop edges if needed
        return view
    }
    
    // This only gets called when SWIFT thinks the view needs to be updated (e.g., zoom levels)
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // Nothing else needed; SwiftUI will size the view,
        // and the layer automatically matches its bounds.
    }
}
