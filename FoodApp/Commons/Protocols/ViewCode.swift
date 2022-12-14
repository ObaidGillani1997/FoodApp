//
//  File.swift
//  FoodApp
//
//  Created by Obaid Khan on 06/06/22.
//

import Foundation

protocol ViewCode {
    func buildViewHierarch()
    func setUpConstraints()
    func additionalConfiguration()
}

extension ViewCode {
    func setupView() {
        buildViewHierarch()
        setUpConstraints()
        additionalConfiguration()
    }

    func buildViewHierarch() {}
    func setUpConstraints() {}
    func additionalConfiguration() {}
}
