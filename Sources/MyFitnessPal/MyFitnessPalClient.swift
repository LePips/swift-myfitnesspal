//
//  MyFitnessPalClient.swift
//  
//
//  Created by Ethan Pippin on 5/21/21.
//

import Foundation
import SwiftSoup

// TODO: Make better completion value
public typealias MyFitnessPalCompletion = (MyFitnessPalError?) -> Void

public typealias MyFitnessPalDayCompletion = (Result<Day, MyFitnessPalError>) -> Void


public class MyFitnessPalClient {
    
    // MARK: public variables
    
    public static let testClient = MyFitnessPalTestClient(username: "Test", password: "")
    
    public let username: String
    private(set) public var userID: String = ""
    private(set) public var loggedIn = false
    
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

    
    // MARK: public functions
    
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
    
    public func getDay(date: Date, completion: @escaping MyFitnessPalDayCompletion) {
        
        guard self.loggedIn else { completion(.failure(.notLoggedIn)); return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayRequest = SiteRequest(path: ["food", "diary", self.username], parameters: ["date": formatter.string(from: date)])
        session.load(request: dayRequest) { result in
            switch result {
            case .success(let response):
                guard let dayPage = String.decodeUTF8(data: response.body) else { completion(.failure(MyFitnessPalError.dayError)); return }
                
                do {
                    try self.parseDay(page: dayPage, completion: completion)
                } catch {
                    completion(.failure(MyFitnessPalError.dayParsingError))
                }
            case .failure(_):
                completion(.failure(MyFitnessPalError.dayError))
            }
        }
    }
    
    public func getDay(year: Int, month: Int, day: Int, completion: @escaping MyFitnessPalDayCompletion) {
        let components = DateComponents(calendar: .current, year: year, month: month, day: day)
        guard let date = components.date else { completion(.failure(MyFitnessPalError.dayError)); return }
        self.getDay(date: date, completion: completion)
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
                
                // TODO: Implement proper json value decoding instead of casting
                let authToken = AuthToken(expiresIn: json["expires_in"] as! Double, accessToken: json["access_token"] as! String, refreshToken: json["refresh_token"] as! String)
                self.setAuthToken(authToken)
                
                // The value recieved in the "user_id" field cannot be
                // casted to NSNumber for some unknown reason
                self.setUserID(json["user_id"] as! String)
                
                self.setLoggedIn()
                
                // TODO: Switch back to getting user metadata once it is complete
                completion(nil)
//                self.getUserMetaData(completion: completion)
            case .failure(_):
                // TODO: Handle error from request properly instead of throwing login error
                completion(MyFitnessPalError.loginError)
            }
        }
    }
    
    private func getUserMetaData(completion: @escaping MyFitnessPalCompletion) {
        
        let requestedFields = [
            "diary_preferences",
            "goal_preferences",
            "unit_preferences",
            "paid_subscriptions",
            "account",
            "goal_displays",
            "location_preferences",
            "system_data",
            "profiles",
            "step_sources",
        ]
        
        var parameterFields = requestedFields.reduce("") { result, current in
            result + "fields[]=\(current)&"
        }
        parameterFields.removeLast()
        
        // TODO: Replace with better error
        guard let authToken = authToken else { completion(MyFitnessPalError.loginError); return }
        
        var headers = authToken.headers
        headers["mfp-user-id"] = userID
        
        let userRequest = APIRequest(path: ["v2", "users", userID], headers: headers, parameters: [:], explicitParameters: parameterFields)
        
        session.load(request: userRequest) { result in
            switch result {
            case .success(_):
                // TODO: Parse json response and create corresponding structures
                completion(nil)
            case .failure(_):
                // TODO: Handle error from request properly instead of throwing login error
                completion(MyFitnessPalError.loginError)
            }
        }
    }
    
    private func parseDay(page: String, completion: @escaping MyFitnessPalDayCompletion) throws {
        
        let soup: Document = try SwiftSoup.parse(page)
        
        // Get meals
        let mealHeaders = try soup.select("tr.meal_header")
        
        var meals: [Meal] = []

        for mealElement in mealHeaders {
            
            var newMeal = Meal(name: try mealElement.getElementsByClass("first alt").text())
            
            var possibleEntry = try mealElement.nextElementSibling()!
            
            while try possibleEntry.children().array()[0].children().array()[0].className() == "js-show-edit-food" {
                let children = possibleEntry.children().array()
                let name = try children[0].text()
                let calories = try children[1].text().macroTrim()
                let carbs = try children[2].text().macroTrim()
                let fat = try children[3].text().macroTrim()
                let protein = try children[4].text().macroTrim()
                let sodium = try children[5].text().macroTrim()
                let sugar = try children[6].text().macroTrim()
                
                let entryMacros = Macros(calories: Int(calories)!, carbs: Int(carbs)!, fat: Int(fat)!, protein: Int(protein)!, sodium: Int(sodium)!, sugar: Int(sugar)!)
                let newEntry = Entry(name: name, macros: entryMacros)
                newMeal.addEntry(newEntry)
                
                possibleEntry = try possibleEntry.nextElementSibling()!
            }
            
            meals.append(newMeal)
        }
        
        // Get totals
        // Order from parsing goes:
        //    1- Daily total
        //    2- Daily goal
        //    3- remaining
        let allTotals = try soup.select("tr.total").array()
        
        // Daily total
        let dailyTotal = allTotals[0].children().array()
        let totalMacros = try parseMacro(from: dailyTotal)
        
        // Daily goal
        let dailyGoal = allTotals[1].children().array()
        let goalMacros = try parseMacro(from: dailyGoal)
        
        // Remaining
        let dailyRemaining = allTotals[2].children().array()
        let remainingMacros = try parseMacro(from: dailyRemaining)
        
        let exerciseCalories = parseExerciseCalories(from: try soup.select("td.extra").text())
        
        // Create Day object
        let day = Day(meals: meals, totalMacros: totalMacros, goalMacros: goalMacros, remainingMacros: remainingMacros, exerciseCalories: exerciseCalories)
        
        completion(.success(day))
    }
    
    private func parseMacro(from elements: [Element]) throws -> Macros {
        
        let calories = try elements[1].text().macroTrim()
        let carbs = try elements[2].text().macroTrim()
        let fat = try elements[3].text().macroTrim()
        let protein = try elements[4].text().macroTrim()
        let sodium = try elements[5].text().macroTrim()
        let sugar = try elements[6].text().macroTrim()
        
        return Macros(calories: Int(calories)!, carbs: Int(carbs)!, fat: Int(fat)!, protein: Int(protein)!, sodium: Int(sodium)!, sugar: Int(sugar)!)
    }
    
    private func parseExerciseCalories(from text: String) -> Int {
        
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: #"\*You've earned (\d+) extra calories from exercise today"#)
        guard let match = regex.firstMatch(in: text, options: [], range: range) else { return 0 }
        guard let tokenRange = Range(match.range(at: 1), in: text) else { return 0 }
        
        guard let casted = Int(text[tokenRange]) else { return 0 }
        
        return casted
    }
}

// MARK: Setters
/*
 Use setters whenever variables on the client are changed.
 This is because many variables are set from completion handlers and makes
 variable setting more declarative and clean.
 */
extension MyFitnessPalClient {
    
    private func setUserID(_ id: String) {
        self.userID = id
    }
    
    private func setAuthToken(_ authToken: AuthToken) {
        self.authToken = authToken
    }
    
    private func setLoggedIn() {
        self.loggedIn = true
    }
}
