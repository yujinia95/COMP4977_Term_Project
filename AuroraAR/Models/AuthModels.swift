//
//  AuthModels.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
import Foundation

struct LoginRequest: Codable {
    let usernameOrEmail: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
    let confirmPassword: String 
}


struct AuthUser: Codable, Identifiable {
    let userId: Int
    let username: String
    let email: String
    let createdAt: String

    var id: Int { userId }
}

struct AuthResponse: Codable {
    let token: String
    let user: AuthUser
}

