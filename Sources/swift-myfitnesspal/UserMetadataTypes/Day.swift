//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/25/21.
//

import Foundation

public struct Day {
    
    public let meals: [Meal]
    public let totalMacros: Macros
    public let goalMacros: Macros
    public let remainingMacros: Macros
    public let exerciseCalories: Int
}
