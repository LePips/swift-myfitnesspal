//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/23/21.
//

import Foundation

public enum MyFitnessPalError: String, Error {
    case notLoggedIn
    case loginError
    case incorrectUsernamePassword
    case loginAuthError
    case dayError
    case dayParsingError
    case foodSearchError
    case foodDetailError
    
    public var localizedDescription: String {
        switch self {
        case .notLoggedIn:
            return "Client has not been logged in"
        default:
            return self.rawValue
        }
    }
}
