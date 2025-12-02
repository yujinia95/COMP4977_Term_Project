//
//  SurfaceARViewRepresentable.swift
//  AuroraAR
//
//  Created by Amal Allaham on 2025-12-02.
//

import SwiftUI

struct SurfaceARViewRepresentable: UIViewControllerRepresentable {
    let colors: [UIColor]

    func makeUIViewController(context: Context) -> SurfaceARViewController {
        let vc = SurfaceARViewController()
        vc.paletteColors = colors
        if let first = colors.first {
            vc.selectedColor = first
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: SurfaceARViewController, context: Context) {}
}
