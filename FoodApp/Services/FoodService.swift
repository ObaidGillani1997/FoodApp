//
//  FoodService.swift
//  FoodApp
//
//  Created by Obaid Khan on 23/04/22.
//

import Foundation
import Alamofire

final class FoodService: FoodServiceProtocol {
    private var sessionManager: Session?
    private let api: FoodAPI

    init(sessionManager: Session, api: FoodAPI) {
        self.sessionManager = sessionManager
        self.api = api
    }

    func getFoods(by name: String, completion: @escaping (Result<FoodsProtocol, Error>) -> Void) {
        request(url: api.getFoods(by: name), completion: completion)
    }

    private func request(url: String,
                         completion: @escaping (Result<FoodsProtocol, Error>) -> Void) {
        sessionManager?.request(url)
            .responseDecodable(of: FoodResult.self) { response in
                switch response.result {
                case .success(let foods):
                    DispatchQueue.main.async {
                        completion(.success(Foods(foods)))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
    }
}
