//
//  FoodItem.swift
//  FoodApp
//
//  Created by Asad Khan on 8/24/22.
//


import Foundation
struct FoodResult : Codable {
    let meals : [FoodItem]?

    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        meals = try values.decodeIfPresent([FoodItem].self, forKey: .meals)
    }

}
