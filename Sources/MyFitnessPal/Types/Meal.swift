//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/25/21.
//

import Foundation

public struct Meal {
    
    private(set) public var name: String
    private(set) public var entries: [Entry] = []
    
    mutating func addEntry(_ entry: Entry) {
        self.entries.append(entry)
    }
}
