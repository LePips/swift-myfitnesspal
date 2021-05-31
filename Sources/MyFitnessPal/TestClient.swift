//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/26/21.
//

import Foundation

public class MyFitnessPalTestClient: MyFitnessPalClient {
    
    private let breakfastEntries: [Entry] = [Entry(name: "Cereal", macros: Macros(calories: 200, carbs: 20, fat: 3, protein: 5, sodium: 4, sugar: 6)),
                                            Entry(name: "Milk", macros: Macros(calories: 140, carbs: 30, fat: 5, protein: 4, sodium: 1, sugar: 2))]
    private let lunchEntries: [Entry] = [Entry(name: "Bread", macros: Macros(calories: 220, carbs: 50, fat: 1, protein: 2, sodium: 3, sugar: 4)),
                                        Entry(name: "Peanut Butter", macros: Macros(calories: 140, carbs: 1, fat: 2, protein: 3, sodium: 4, sugar: 5))]
    private let dinnerEntries: [Entry] = [Entry(name: "Steak", macros: Macros(calories: 500, carbs: 1, fat: 3, protein: 4, sodium: 5, sugar: 2)),
                                        Entry(name: "Potatoes", macros: Macros(calories: 400, carbs: 1, fat: 2, protein: 3, sodium: 4, sugar: 5))]
    
    internal override init(username: String, password: String) {
        super.init(username: "", password: "")
    }
    
    override public func login(completion: @escaping MyFitnessPalLoginCompletion) {
        completion(.success(()))
    }
    
    override public func getDay(date: Date, completion: @escaping MyFitnessPalDayCompletion) {
        let breakfast = Meal(name: "Breakfast", entries: breakfastEntries)
        let lunch = Meal(name: "Lunch", entries: lunchEntries)
        let dinner = Meal(name: "Dinner", entries: dinnerEntries)
        
        let day = Day(meals: [breakfast, lunch, dinner],
                      totalMacros: Macros(calories: 200, carbs: 1, fat: 2, protein: 3, sodium: 4, sugar: 5),
                      goalMacros: Macros(calories: 2100, carbs: 100, fat: 110, protein: 120, sodium: 130, sugar: 140),
                      remainingMacros: Macros(calories: 1900, carbs: 99, fat: 108, protein: 11, sodium: 126, sugar: 135),
                      exerciseCalories: 11)
        
        completion(.success(day))
    }
    
    override public func getDay(year: Int, month: Int, day: Int, completion: @escaping MyFitnessPalDayCompletion) {
        getDay(date: Date(), completion: completion)
    }
}
