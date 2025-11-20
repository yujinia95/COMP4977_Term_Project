//
//  Untitled.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
import UIKit

struct DetectedColor: Identifiable, Hashable {
    let id = UUID()
    let uiColor: UIColor
    let hex: String
    let name: String
}

