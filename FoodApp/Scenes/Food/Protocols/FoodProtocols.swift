//
//  FoodProtocols.swift
//  FoodApp
//
//  Created by Obaid Khan on 12/04/22.
//

import Foundation

protocol FoodViewModelProtocol {
    var delegate: FoodViewModelDelegateProtocol? { get set }
    var foodNavigation: FoodNavigationProtocol? { get set }
    var service: FoodServiceProtocol { get set }

    func loadFood(searchText: String)
    func didTapFoodCell(food: FoodItem)
}

protocol FoodViewModelDelegateProtocol: AnyObject {
    func didLoadedFood(foods: [FoodItem])
    func didFailLoadedFood(title: String, error: String)
}

protocol FoodNavigationProtocol: AnyObject {
    func goToFoodDetail(food: FoodItem)
}
