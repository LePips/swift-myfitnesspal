//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/22/21.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

protocol HTTPRequest {
    var base: String { get }
    var path: [String] { get set }
    var body: Data? { get set }
    var headers: [String: String] { get set }
    var parameters: [String: String] { get set }
    // TODO: Used as a work around for an array of objects to be parameterized.
    var explicitParameters: String { get set }
    
    var method: HTTPMethod { get }
    
    var url: URL? { get }
    var urlRequest: URLRequest? { get }
}

struct SiteRequest: HTTPRequest {
    
    var base: String = "https://www.myfitnesspal.com"
    var path: [String]
    var body: Data? = nil
    var headers: [String: String]
    var parameters: [String: String]
    var explicitParameters: String
    
    var method: HTTPMethod
    
    var url: URL? {
        guard var components = URLComponents(string: base + "/" + path.joined(separator: "/")) else { return nil }
        components.queryItems = parameters.map({ URLQueryItem(name: $0, value: $1) })
        components.query?.append(explicitParameters)
        
        return components.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
    
    init(path: [String], body: Data? = nil, headers: [String: String] = [:], parameters: [String: String] = [:], explicitParameters: String = "", method: HTTPMethod = .GET) {
        self.path = path
        self.body = body
        self.headers = headers
        self.parameters = parameters
        self.method = method
        self.explicitParameters = explicitParameters
    }
}

struct APIRequest: HTTPRequest {
    
    var base: String = "https://api.myfitnesspal.com"
    var path: [String]
    var body: Data? = nil
    var headers: [String : String]
    var parameters: [String: String]
    var explicitParameters: String
    
    var method: HTTPMethod = .GET
    
    var url: URL? {
        guard var components = URLComponents(string: base + "/" + path.joined(separator: "/")) else { return nil }
        components.queryItems = parameters.map({ URLQueryItem(name: $0, value: $1) })
        components.query?.append(explicitParameters)
        
        return components.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
    
    init(path: [String], headers: [String: String] = [:], parameters: [String: String] = [:], explicitParameters: String = "") {
        self.path = path
        self.headers = headers
        self.parameters = parameters
        self.explicitParameters = explicitParameters
    }
}
