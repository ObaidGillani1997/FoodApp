//
//  FoodViewModel.swift
//  FoodApp
//
//  Created by Obaid Khan on 10/04/22.
//

import Foundation

final class FoodViewModel: FoodViewModelProtocol {
    weak var delegate: FoodViewModelDelegateProtocol?
    weak var foodNavigation: FoodNavigationProtocol?
    var service: FoodServiceProtocol
    init(service: FoodServiceProtocol) {
        self.service = service
    }
    func loadFood(searchText: String) {
        let searchTextFiltered = searchText.replacingOccurrences(of: " ", with: "_")
        service.getFoods(by: searchTextFiltered) { [weak self] response in
            self?.handleResponse(response: response)
        }
    }
    
    func didTapFoodCell(food: FoodItem) {
      foodNavigation?.goToFoodDetail(food: food)
    }
    
    private func handleResponse(response: Result<FoodsProtocol, Error>) {
        switch response {
        case .success(let foods):
            self.delegate?.didLoadedFood(foods: foods.foods)
        case .failure(let error):
            self.delegate?.didFailLoadedFood(title: "Error on load foods.", error: error.localizedDescription)
        }
    }
}
