//
//  SurfaceARViewController.swift
//  AuroraAR
//
//  Created by Amal Allaham on 2025-12-02.
//

import UIKit
import ARKit
import RealityKit

class SurfaceARViewController: UIViewController, ARSessionDelegate {

    // AR
    var arView: ARView!

    // Colors injected from SwiftUI (converted from hex)
    var paletteColors: [UIColor] = [.systemBlue]
    var selectedColor: UIColor = .systemBlue

    // Show plane-detected alert once
    private var hasShownSurfaceAlert = false


    override func loadView() {
        arView = ARView(frame: .zero)
        view = arView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        startPlaneDetection()
        setupColorPalette()

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(recognizer:))
        )
        arView.addGestureRecognizer(tapGesture)
    }


    func startPlaneDetection() {
        arView.automaticallyConfigureSession = false

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic

        arView.session.delegate = self
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }


    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard !hasShownSurfaceAlert else { return }

        if anchors.contains(where: { $0 is ARPlaneAnchor }) {
            hasShownSurfaceAlert = true

            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Surface Detected",
                    message: "You can now tap to place rectangles on the table or floor.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }



    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: arView)

        // Raycast against horizontal surfaces
        let results = arView.raycast(
            from: tapLocation,
            allowing: .existingPlaneGeometry,
            alignment: .horizontal
        )

        guard let firstResult = results.first else { return }

        let transform = firstResult.worldTransform
        var position = SIMD3<Float>(
            transform.columns.3.x,
            transform.columns.3.y,
            transform.columns.3.z
        )

        position.y += 0.001

        let rectangle = createRectangle()

        let anchor = AnchorEntity(world: position)
        anchor.addChild(rectangle)
        arView.scene.addAnchor(anchor)
    }


    func createRectangle() -> ModelEntity {
        // Smaller square: 15 cm x 15 cm
        let size: Float = 0.15
        let mesh = MeshResource.generatePlane(width: size, height: size)

        let material = SimpleMaterial(
            color: selectedColor,
            roughness: 0.25,
            isMetallic: false
        )

        let entity = ModelEntity(mesh: mesh, materials: [material])

        
        let rotation = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(1, 0, 0))
        entity.orientation = rotation

        return entity
    }


    func setupColorPalette() {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stack)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 80),

            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stack.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])

        for (index, color) in paletteColors.enumerated() {
            let button = UIButton(type: .system)
            button.backgroundColor = color
            button.layer.cornerRadius = 18
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.tintColor = .clear
            button.widthAnchor.constraint(equalToConstant: 36).isActive = true
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true

            button.tag = index
            button.addTarget(self,
                             action: #selector(colorButtonTapped(_:)),
                             for: .touchUpInside)

            stack.addArrangedSubview(button)
        }

        if let first = paletteColors.first {
            selectedColor = first
        }
    }

    @objc
    func colorButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < paletteColors.count else { return }

        selectedColor = paletteColors[index]

        UIView.animate(withDuration: 0.1,
                       animations: {
                           sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                       },
                       completion: { _ in
                           UIView.animate(withDuration: 0.1) {
                               sender.transform = .identity
                           }
                       })
    }
}
