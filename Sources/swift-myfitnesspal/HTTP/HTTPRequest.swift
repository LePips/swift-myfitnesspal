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

protocol MyFitnessPalRequest {
    var base: String { get }
    var path: [String] { get set }
    var body: Data? { get set }
    var headers: [String: String] { get set }
    var parameters: [String: String] { get set }
    
    var method: HTTPMethod { get }
    
    var url: URL? { get }
    var urlRequest: URLRequest? { get }
}

struct SiteRequest: MyFitnessPalRequest {
    
    var base: String = "https://www.myfitnesspal.com"
    var path: [String]
    var body: Data? = nil
    var headers: [String: String]
    var parameters: [String: String]
    
    var method: HTTPMethod
    
    var url: URL? {
        guard var components = URLComponents(string: base + "/" + path.joined(separator: "/")) else { return nil }
        components.queryItems = parameters.map({ URLQueryItem(name: $0, value: $1) })
        
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
    
    init(path: [String], body: Data? = nil, headers: [String: String] = [:], parameters: [String: String] = [:], method: HTTPMethod = .GET) {
        self.path = path
        self.body = body
        self.headers = headers
        self.parameters = parameters
        self.method = method
    }
}

struct APIRequest: MyFitnessPalRequest {
    
    var base: String = "https://www.api.myfitnesspal.com"
    var path: [String]
    var body: Data? = nil
    var headers: [String : String]
    var parameters: [String: String]
    
    var method: HTTPMethod = .GET
    
    var url: URL? {
        guard var components = URLComponents(string: base + "/" + path.joined(separator: "/")) else { return nil }
        
        for (key, value) in parameters {
            let stringValue = String(describing: value)
            components.queryItems?.append(URLQueryItem(name: key, value: stringValue))
        }
        
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
    
    init(path: [String], headers: [String: String] = [:], parameters: [String: String] = [:]) {
        self.path = path
        self.headers = headers
        self.parameters = parameters
    }
}
