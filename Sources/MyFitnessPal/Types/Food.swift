//
//  File.swift
//  
//
//  Created by Ethan Pippin on 6/3/21.
//

import Foundation

// It is important to note that the id/version value from the endpoint
// associated with each food is not guaranteed to query with /v2/foods/<id>
public struct Food: Decodable {
    
    // TODO: Implement tags and serving size
    
    public let name: String
    public let nutritionalContents: NutritionalContents
    
    enum CodingKeys: String, CodingKey {
        case name = "description"
        case nutritionalContents = "nutritional_contents"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(for: CodingKeys.name)
        self.nutritionalContents = try container.decode(for: .nutritionalContents)
    }
}

// MARK: Decoding wrappers

struct ResponseWrapper: Decodable {
    let items: FoodList
}

struct FoodList: Decodable {
    
    struct ItemWrapper: Decodable {
        let item: Food
    }
    
    let food: [Food]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let wrapper = try container.decode([ItemWrapper].self)
        self.food = wrapper.map({ $0.item })
    }
}
