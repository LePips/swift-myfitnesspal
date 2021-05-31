//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/31/21.
//

import Foundation


extension UserDefaults {
    
    enum Cookie {
        
        fileprivate static let suite = UserDefaults(suiteName: "swift-myfitnesspal-defaults")!
        
        static func hasUser() -> Bool {
            return false
        }
        
        static func store(_ cookie: HTTPCookie) {
            
        }
        
        static func clear() {
            
        }
        
        static func retrieve() -> [HTTPCookie] {
            return []
        }
    }
}

extension HTTPCookie {
    func save(cookieProperties: [HTTPCookiePropertyKey : Any]) -> Data {
        let data = NSKeyedArchiver.archivedData(withRootObject: cookieProperties)
        return data
    }

    func arquive() -> Data? {
        guard let properties = self.properties else {
            return nil
        }
        return save(cookieProperties: properties)
    }
}
