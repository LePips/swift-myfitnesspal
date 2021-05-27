//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/23/21.
//

import Foundation

public struct AuthToken {
    
    private let expireDate: Date
    public let accessToken: String
    public let refreshToken: String
    
    public var hasExpired: Bool {
        return Date() > expireDate
    }
    
    var headers: [String: String] {
        return ["Authorization": "Bearer \(accessToken)", "mfp-client-id": "mfp-main-js"]
    }
    
    init(expiresIn: Double, accessToken: String, refreshToken: String) {
        self.expireDate = Date().addingTimeInterval(expiresIn)
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
