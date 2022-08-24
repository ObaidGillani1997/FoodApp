//
//  Foods.swift
//  FoodApp
//
//  Created by Obaid Khan on 25/05/22.
//

import Foundation

struct Foods: FoodsProtocol {
    let foods: [FoodItem]

    init(_ foodResult: FoodResult) {
        self.foods = foodResult.meals ?? []
    }
}
