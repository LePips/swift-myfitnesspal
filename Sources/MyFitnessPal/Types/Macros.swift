//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/25/21.
//

import Foundation

// TODO: Look at replacing Macros with NutritionalContents
public struct Macros {
    
    public let calories: Int
    public let carbs: Int
    public let fat: Int
    public let protein: Int
    public let sodium: Int
    public let sugar: Int
}

public struct NutritionalContents: Decodable {
    
    struct Energy: Decodable {
        public let unit: String
        let value: Double
    }
    
    private(set) public var calcium: Double = 0
    private(set) public var carbohydrates: Double = 0
    private(set) public var cholesterol: Double = 0
    let energy: Energy
    private(set) public var fat: Double = 0
    private(set) public var fiber: Double = 0
    private(set) public var iron: Double = 0
    private(set) public var monounsaturatedFat: Double = 0
    private(set) public var polyunsaturatedFat: Double = 0
    private(set) public var potassium: Double = 0
    private(set) public var protein: Double = 0
    private(set) public var saturatedFat: Double = 0
    private(set) public var sodium: Double = 0
    private(set) public var sugar: Double = 0
    private(set) public var transFat: Double = 0
    private(set) public var vitaminA: Double = 0
    private(set) public var vitaminC: Double = 0
    
    public var calories: Double {
        return self.energy.unit == "calories" ? energy.value : 0
    }
    
    enum CodingKeys: String, CodingKey {
        case monounsaturatedFat = "monounsaturated_fat"
        case polyunsaturatedFat = "polyunsaturated_fat"
        case saturatedFat = "saturated_fat"
        case transFat = "trans_fat"
        case vitaminA = "vitamin_a"
        case vitaminC = "vitamin_c"
        case calcium
        case carbohydrates
        case cholesterol
        case energy
        case fat
        case fiber
        case iron
        case potassium
        case protein
        case sodium
        case sugar
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        monounsaturatedFat = container.decodeDefault(for: .monounsaturatedFat, value: 0)
        polyunsaturatedFat = container.decodeDefault(for: .polyunsaturatedFat, value: 0)
        saturatedFat = container.decodeDefault(for: .saturatedFat, value: 0)
        transFat = container.decodeDefault(for: .transFat, value: 0)
        vitaminA = container.decodeDefault(for: .vitaminA, value: 0)
        vitaminC = container.decodeDefault(for: .vitaminC, value: 0)
        calcium = container.decodeDefault(for: .calcium, value: 0)
        carbohydrates = container.decodeDefault(for: .carbohydrates, value: 0)
        cholesterol = container.decodeDefault(for: .cholesterol, value: 0)
        energy = try container.decode(for: .energy)
        fat = container.decodeDefault(for: .fat, value: 0)
        fiber = container.decodeDefault(for: .fiber, value: 0)
        iron = container.decodeDefault(for: .iron, value: 0)
        potassium = container.decodeDefault(for: .potassium, value: 0)
        protein = container.decodeDefault(for: .protein, value: 0)
        sodium = container.decodeDefault(for: .sodium, value: 0)
        sugar = container.decodeDefault(for: .sugar, value: 0)
    }
}
