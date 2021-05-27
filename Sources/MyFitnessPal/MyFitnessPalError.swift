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
}