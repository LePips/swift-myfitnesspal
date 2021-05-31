//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/23/21.
//

import Foundation

/*
 An auth token used for some MyFitnessPal API calls
 */
struct AuthToken {
    
    private let expireDate: Date
    let accessToken: String
    let refreshToken: String
    
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
