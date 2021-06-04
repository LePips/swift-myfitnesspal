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
    
    func decodeNil<T: Decodable>(for key: K) -> T? {
        do {
            return try decode(for: key)
        } catch {
            return nil
        }
    }
    
    func decodeDefault<T: Decodable>(for key: K, value: T) -> T {
        do {
            return try decode(for: key)
        } catch {
            return value
        }
    }
}
