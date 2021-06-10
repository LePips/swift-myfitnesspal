//
//  File.swift
//  
//
//  Created by Ethan Pippin on 5/30/21.
//

import Foundation

/// Completion for logging in
public typealias MyFitnessPalLoginCompletion = (Result<Void, MyFitnessPalError>) -> Void

/// Completion for retrieving a day
public typealias MyFitnessPalDayCompletion = (Result<Day, MyFitnessPalError>) -> Void

/// Completion for searching food
public typealias MyFitnessPalFoodSearchCompletion = (Result<[FoodSearchResult], MyFitnessPalError>) -> Void

/// Completion for retrieving details from a food search result
public typealias MyFitnessPalFoodDetailCompletion = (Result<Food, MyFitnessPalError>) -> Void
