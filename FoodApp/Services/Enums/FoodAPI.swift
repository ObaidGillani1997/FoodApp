//
//  ApiFoods.swift
//  FoodApp
//
//  Created by Obaid Khan on 04/05/22.
//

import Foundation

enum FoodAPI {
    
    case food
    
    private var baseURL: String {
        switch self {
        case .food:
            return "https://www.themealdb.com/api/json/v1/1"
        }
    }

    func getFoods(by name: String) -> String  { "\(baseURL)/search.php?s=\(name)" }
}
