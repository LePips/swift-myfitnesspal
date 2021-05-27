//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/23/21.
//

import Foundation

extension String {
    
    static func decodeUTF8(data: Data?) -> String? {
        guard let data = data else { return nil }
        return String(decoding: data, as: UTF8.self)
    }
    
    func macroTrim() -> String {
        return self.split(separator: " ")[0].replacingOccurrences(of: ",", with: "")
    }
}
