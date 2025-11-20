//
//  AuthModels.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
import Foundation

// Login request works only for EMAIL on the app, but USERNAME and EMAIL work using postman to the backend API
struct LoginRequest: Codable {
    let usernameOrEmail: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
}

