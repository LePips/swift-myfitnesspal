//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/22/21.
//

import Foundation

public class SimpleError: Error {
    
    private var message: String
    
    public init(_ message: String) {
        self.message = message
    }
    
    var localizedDescription: String {
        return message
    }
}

extension URLSession {
    
    // TODO - fix completion
    func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        
        guard let urlRequest = request.urlRequest else {
            completion(.failure(HTTPError(SimpleError("Could not construct url request"))))
            return
        }
        
        self.dataTask(with: urlRequest) { data, urlResponse, error in
            self.process(data: data, urlResponse: urlResponse, error: error, completion: completion)
        }.resume()
    }
    
    fileprivate func process(data: Data?, urlResponse: URLResponse?, error: Error?, completion: @escaping (HTTPResult) -> Void) {

        guard error == nil else {
            completion(.failure(HTTPError(error!)))
            return
        }
        
        if let httpResponse = urlResponse as? HTTPURLResponse {
            completion(.success(HTTPResponse(httpResponse, body: data)))
        } else {
            completion(.failure(HTTPError(SimpleError("Response is not valid HTTPURLResponse"))))
        }
    }
}
