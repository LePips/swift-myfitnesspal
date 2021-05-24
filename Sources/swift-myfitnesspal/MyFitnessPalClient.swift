//
//  MyFitnessPalClient.swift
//  
//
//  Created by Ethan Pippin on 5/21/21.
//

import Foundation

// TODO: Make better completion value
public typealias MyFitnessPalCompletion = (MyFitnessPalError?) -> Void

public class MyFitnessPalClient {
    
    // MARK: public variables
    
    public let username: String
    private(set) public var userID: String = ""
    
    // TODO: Don't store plainly
    private let password: String
    
    // MARK: private variables
    
    private let session: URLSession
    private var authToken: AuthToken? = nil
    
    // MARK: init
    
    /// Initialize client with username and password of current user
    public init(username: String, password: String) {
        
        self.username = username
        self.password = password
        
        // Individual sessions for each client
        self.session = URLSession(configuration: .default)
    }
}

// MARK: public functions
extension MyFitnessPalClient {
    
    public func login(completion: @escaping MyFitnessPalCompletion) {
        
        let loginRequest = SiteRequest(path: ["account", "login"])
        session.load(request: loginRequest) { result in
            switch result {
            case .success(let response):
                guard let loginPage = String.decodeUTF8(data: response.body) else { completion(MyFitnessPalError.loginError); return }
                let authToken = self.parseLoginPageForToken(loginPage)
                self.postLogin(token: authToken, completion: completion)
            case .failure(_):
                // TODO: Handle error from request properly instead of throwing login error
                completion(MyFitnessPalError.loginError)
            }
        }
    }
}

// MARK: private functions
extension MyFitnessPalClient {
    
    private func parseLoginPageForToken(_ page: String) -> String {
        
        // javascript AUTH_TOKEN variable is at the top of the page and
        // swift regex will crash on long texts sometimes, divide to simplify
        // choosing 4 here is arbitrary
        let range = NSRange(location: 0, length: page.utf8.count / 4)
        let regex = try! NSRegularExpression(pattern: #"var AUTH_TOKEN = "(.*)""#, options: [])
        let match = regex.firstMatch(in: page, options: [], range: range)
        match?.range(at: 1)
        let tokenRange = Range(match!.range(at: 1), in: page)!
        
        return String(page[tokenRange])
    }
    
    private func postLogin(token: String, completion: @escaping MyFitnessPalCompletion) {
        let parameters = ["authenticity_token": token, "username": self.username, "password": self.password]
        
        let loginRequest = SiteRequest(path: ["account", "login"], body: nil, headers: [:], parameters: parameters, method: .POST)
        session.load(request: loginRequest) { result in
            switch result {
            case .success(let response):
                guard let page = String.decodeUTF8(data: response.body) else { completion(MyFitnessPalError.loginError); return }
                guard !page.contains("Incorrect") else { completion(MyFitnessPalError.incorrectUsernamePassword); return }
                
                self.getAuthToken(completion: completion)
            case .failure(_):
                // TODO: Handle error from request properly instead of throwing login error
                completion(MyFitnessPalError.loginError)
            }
        }
    }
    
    private func getAuthToken(completion: @escaping MyFitnessPalCompletion) {
        let authRequest = SiteRequest(path: ["user", "auth_token"], parameters: ["refresh": "true"])
        session.load(request: authRequest) { result in
            switch result {
            case .success(let response):
                // TODO: Handle error from auth response with better information
                guard let json = JSON.decode(data: response.body) else { completion(MyFitnessPalError.loginAuthError); return }
                
                // TODO: Implement proper dictionary access
                let authToken = AuthToken(expiresIn: json["expires_in"] as! Double, accessToken: json["access_token"] as! String, refreshToken: json["refresh_token"] as! String)
                self.setAuthToken(authToken)
                
                // The value recieved in the "user_id" field cannot be
                // casted to NSNumber for some unknown reason
                self.setUserID(json["user_id"] as! String)
                
                completion(nil)
            case .failure(_):
                // TODO: Handle error from request properly instead of throwing login error
                completion(MyFitnessPalError.loginError)
            }
        }
    }
}

// MARK: Setters
/*
 Use setters whenever variables on the client are changed.
 This is because many variables are set from completion handlers and cleans things up.
 */
extension MyFitnessPalClient {
    
    private func setUserID(_ id: String) {
        self.userID = id
    }
    
    private func setAuthToken(_ authToken: AuthToken) {
        self.authToken = authToken
    }
}
