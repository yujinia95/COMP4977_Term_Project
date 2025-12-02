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

        arView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        )
    }

    func startPlaneDetection () {
        arView.automaticallyConfigureSession = true

        let configuration = ARWorldTrackingConfiguration()
        // For walls
        configuration.planeDetection = [.vertical]
        configuration.environmentTexturing = .automatic

        arView.session.delegate = self
        arView.session.run(configuration)
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard !hasShownSurfaceAlert else { return }

        if anchors.contains(where: { $0 is ARPlaneAnchor }) {
            hasShownSurfaceAlert = true

            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Surface Detected",
                    message: "You can now tap to place rectangles on the wall.",
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

        let results = arView.raycast(
            from: tapLocation,
            allowing: .estimatedPlane,
            alignment: .vertical
        )

        if let firstResult = results.first {
            let worldPos = simd_make_float3(firstResult.worldTransform.columns.3)

            let rectangle = createRectangle()
            placeObject(object: rectangle, at: worldPos)
        }
    }

    func createRectangle() -> ModelEntity {
        let width: Float = 0.4      // 40 cm
        let height: Float = 0.4     // 40 cm

        let mesh = MeshResource.generatePlane(width: width, height: height)
        let material = SimpleMaterial(color: selectedColor, roughness: 0.3, isMetallic: false)

        let entity = ModelEntity(mesh: mesh, materials: [material])

        // For vertical plane, plane already faces user, no rotation needed
        return entity
    }

    func placeObject(object: ModelEntity, at location: SIMD3<Float>) {
        let objectAnchor = AnchorEntity(world: location)
        objectAnchor.addChild(object)
        arView.scene.addAnchor(objectAnchor)
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
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)

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
