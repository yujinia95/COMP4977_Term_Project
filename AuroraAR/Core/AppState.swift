//
//  AppState.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
import Foundation
import Combine

final class AppState: ObservableObject {
    // Tracks if user is logged in
    @Published var isLoggedIn: Bool = false

    // Logout without token handling: just flip the login state
    func logout() {
        isLoggedIn = false
    }
}
