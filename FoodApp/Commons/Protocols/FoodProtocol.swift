//
//  FoodProtocol.swift
//  FoodApp
//
//  Created by Obaid Khan on 17/06/22.
//

import Foundation

protocol FoodItemProtocol {
    
    var id: String { get }
    var name: String { get }
    var thumb: String { get }
    var category: String? { get }
    var instructions: String? { get }
}

