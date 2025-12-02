//
//  GenPaletteViewModel.swift
//  AuroraAR
//
//  Created by Evan Vink on 2025-11-21.
//

import Foundation

import Combine


struct ColorAPIResponse: Codable {
    let colors: [ColorAPIItem]
}

struct ColorAPIItem: Codable {
    let name: APIName
    let hex: APIHex
    let rgb: APIRGB
}

struct APIName: Codable {
    let value: String
}

struct APIHex: Codable {
    let value: String  
}

struct APIRGB: Codable {
    let r: Int
    let g: Int
    let b: Int
}



@MainActor
class PaletteViewModel: ObservableObject {
    @Published var palette: [PaletteColor] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Generate a random hex string
    func randomHex() -> String {
        let number = Int.random(in: 0...(0xFFFFFF))
        return String(format: "%06X", number)
    }

    func fetchPalette() {
        let randomHexValue = randomHex()

        var components = URLComponents(string: "https://www.thecolorapi.com/scheme")!
        components.queryItems = [
            URLQueryItem(name: "hex", value: randomHexValue),
            URLQueryItem(name: "mode", value: "triad"),
            URLQueryItem(name: "count", value: "2")
        ]

        guard let url = components.url else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(ColorAPIResponse.self, from: data)

                self.palette = decoded.colors.map { item in
                    PaletteColor(
                        name: item.name.value,
                        hex: item.hex.value,
                        r: item.rgb.r,
                        g: item.rgb.g,
                        b: item.rgb.b
                    )
                }

            } catch {
                self.errorMessage = "Failed: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }
}
