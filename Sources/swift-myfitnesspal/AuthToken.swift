//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/23/21.
//

import Foundation

struct AuthToken {
    
    private let expireDate: Date
    let accessToken: String
    let refreshToken: String
    
    var hasExpired: Bool {
        return Date() > expireDate
    }
    
    init(expiresIn: Double, accessToken: String, refreshToken: String) {
        self.expireDate = Date().addingTimeInterval(expiresIn)
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
