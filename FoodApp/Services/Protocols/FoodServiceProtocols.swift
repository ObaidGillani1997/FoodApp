//
//  FoodServiceProtocols.swift
//  FoodApp
//
//  Created by Obaid Khan on 23/04/22.
//

import Foundation
import Alamofire

protocol FoodServiceProtocol: AnyObject {
    func getFoods(by name: String, completion: @escaping (Result<FoodsProtocol, Error>) -> Void)
}
