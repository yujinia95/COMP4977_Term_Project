//
//  ColorsModels.swift
//  AuroraAR
//
//  Created by Evan Vink on 2025-12-01.
//

import Foundation



struct ColorRequest: Codable, Identifiable {
    var id: String { colorCode }
    let colorId: Int
    let colorName: String
    let colorCode: String
}

struct ColorById: Codable {
    let ColorId: Int
}

struct ColorResponse: Codable {
    let colorName: String
    let colorCode: String
}
