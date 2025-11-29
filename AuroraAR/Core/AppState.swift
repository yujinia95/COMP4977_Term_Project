//
//  AppState.swift
//  AuroraAR
//
//  Created by Amal Allaham on 2025-11-19.
//
import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false

    @Published var authToken: String?
    @Published var currentUser: AuthUser?

 

    func setSession(token: String, user: AuthUser) {
        self.authToken = token
        self.currentUser = user
        self.isLoggedIn = true

         UserDefaults.standard.set(token, forKey: "authToken")
    }

    func logout() {
        authToken = nil
        currentUser = nil
        isLoggedIn = false

         UserDefaults.standard.removeObject(forKey: "authToken")
    }
}
