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
    
    public var sample: Day {
        
        let total = Macros(calories: 1234, carbs: 93, fat: 19, protein: 102, sodium: 1200, sugar: 33)
        let goal = Macros(calories: 2100, carbs: 200, fat: 40, protein: 180, sodium: 2300, sugar: 92)
        let remaining = Macros(calories: goal.calories - total.calories,
                               carbs: goal.carbs - total.carbs,
                               fat: goal.fat - total.fat,
                               protein: goal.protein - total.protein,
                               sodium: goal.sodium - total.sodium,
                               sugar: goal.sugar - total.sugar)
        
        return Day(meals: [], totalMacros: total, goalMacros: goal, remainingMacros: remaining, exerciseCalories: 11)
    }
}
