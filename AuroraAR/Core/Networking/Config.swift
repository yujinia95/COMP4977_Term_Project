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
    static let loginEndpoint    = "/api/auth/login"
    static let registerEndpoint = "/api/auth/register"
    
    static let ColorsEndpoint = "/api/colors"
    static let colorsByIDEndpoint   = "/api/colors/"
    
    // Backend Complete URL with endpoints
    static var loginURL: URL { URL(string: baseURL + loginEndpoint)! }
    static var registerURL: URL { URL(string: baseURL + registerEndpoint)! }
    static var colorsURL: URL { URL(string: baseURL + ColorsEndpoint)! }
    
    static func colorByIDURL(_ id: Int) -> URL {
            return URL(string: baseURL + colorsByIDEndpoint + "\(id)")!
    }
}
