//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/24/21.
//

import Foundation

extension KeyedDecodingContainer {
    func decode<T: Decodable>(for key: K) throws -> T {
        return try decode(T.self, forKey: key)
    }
}
