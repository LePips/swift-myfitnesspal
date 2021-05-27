//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/23/21.
//

import Foundation

typealias JSON = [String: AnyObject]

extension JSON {
    
    static func decode(data: Data?) -> JSON? {
        guard let data = data else { return nil }
        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON
        return json
    }
}
