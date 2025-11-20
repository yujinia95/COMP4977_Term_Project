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
}

