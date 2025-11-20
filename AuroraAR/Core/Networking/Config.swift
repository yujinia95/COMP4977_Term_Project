//
//  Untitled.swift
//  AuroraAR
//
//  Created by Yujin Jeong on 2025-11-19.
//
import Foundation

enum Config {
    
    // Backend hosted URL
    static let baseURL = "https://aurora-bcbjb2g9h3g6f3em.canadacentral-01.azurewebsites.net"
    
    // Backend endpoints
    static let loginEndpoint    = "/api/users/login"
    static let registerEndpoint = "/api/users/register"
    
    // Backend Complete URL with endpoints
    static var loginURL: URL { URL(string: baseURL + loginEndpoint)! }
    static var registerURL: URL { URL(string: baseURL + registerEndpoint)! }
}

