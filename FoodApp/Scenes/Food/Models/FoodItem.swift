//
//  FoodResult.swift
//  FoodApp
//
//  Created by Asad Khan on 8/24/22.
//

import Foundation
struct FoodItem: FoodItemProtocol, Codable {
    let id: String
    let name: String
    let thumb: String
    let category: String?
    let instructions: String?


    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumb = "strMealThumb"
        case category = "strCategory"
        case instructions = "strInstructions"
        
    }
}
