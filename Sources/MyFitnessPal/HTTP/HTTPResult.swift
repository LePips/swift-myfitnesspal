//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/22/21.
//

import Foundation

typealias HTTPResult = Result<HTTPResponse, HTTPError>

struct HTTPResponse {
    let response: HTTPURLResponse
    let body: Data?
    
    init(_ response: HTTPURLResponse, body: Data?) {
        self.response = response
        self.body = body
    }
}

struct HTTPError: Error {
    
    // TODO - provide more information per the cause of error
    private let _error: Error
    
    init(_ error: Error) {
        _error = error
    }
}
