//
//  FoodCollectionViewController.swift
//  FoodApp
//
//  Created by Obaid Khan on 10/04/22.
//

import UIKit

final class FoodViewController: UICollectionViewController {
    private var viewModel: FoodViewModelProtocol?
    private var foodList: [FoodItem] = []
 
    private var isLoading: Bool = true
    private var debouncer: Debouncer!
    
    var searchController: UISearchController!
    
    convenience init(viewModel: FoodViewModelProtocol) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        isLoading = false
        collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return isLoading ? 0 : foodList.count
        default:
            return foodList.isEmpty && !isLoading ? 1 : 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return foodCell(indexPath: indexPath)
        } else if indexPath.section == 1 {
            return emptyCell(indexPath: indexPath)
        }

        return loadingCell(indexPath: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let food = foodList[indexPath.row]
            viewModel?.didTapFoodCell(food: food)
            changeToLoadingState()
        }
    }

    private func emptyCell(indexPath: IndexPath) -> EmptyCollectionViewCell {
        var emptyCell = EmptyCollectionViewCell(frame: .zero)
        if let dequeCell = collectionView
            .dequeueReusableCell(EmptyCollectionViewCell.self, for: indexPath) {
            dequeCell.setupCell()
            emptyCell = dequeCell
        }

        return emptyCell
    }

    private func foodCell(indexPath: IndexPath) -> FoodCollectionViewCell {
        var foodCell = FoodCollectionViewCell()
        if let dequeCell = collectionView.dequeueReusableCell(FoodCollectionViewCell.self, for: indexPath) {
            let recipe = foodList[indexPath.row]
            dequeCell.setupCell(food: recipe)
            foodCell = dequeCell
        }

        return foodCell
    }

    private func loadingCell(indexPath: IndexPath) -> LoadingCollectionViewCell {
        var loadingCell = LoadingCollectionViewCell(frame: .zero)
        if let dequeCell = collectionView
            .dequeueReusableCell(LoadingCollectionViewCell.self, for: indexPath) {
            dequeCell.setupCell()
            loadingCell = dequeCell
        }

        return loadingCell
    }

    private func changeToLoadingState() {
        isLoading = true
        collectionView.reloadData()
    }

    private func showAlertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}

extension FoodViewController {
    func configureUI() {
        self.navigationItem.title = "Food App"
        setUpSearchController()
        collectionView?.register(EmptyCollectionViewCell.self)
        collectionView?.register(FoodCollectionViewCell.self)
        collectionView.register(LoadingCollectionViewCell.self)
    }
    
    func configureData() {
        viewModel?.foodNavigation = self
        debouncer = Debouncer(delay: 0.7)
        viewModel?.loadFood(searchText: "")
    }
}

extension FoodViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 1 && isLoading == false ? CGSize(width: view.frame.width, height: 65) : CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if foodList.isEmpty {
            let margins = view.safeAreaInsets.bottom + view.safeAreaInsets.top
            return CGSize(width: view.bounds.width,
                          height: view.bounds.width - margins)
        }

        let foodSize = (view.bounds.width / 2)
        return CGSize(width: foodSize, height: foodSize)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension FoodViewController: FoodNavigationProtocol {
    func goToFoodDetail(food: FoodItem) {
        let foodDetailsView = FoodDetailsViewController(food: food)
        foodDetailsView.view.backgroundColor = .systemBackground
        self.navigationController?.pushViewController(foodDetailsView, animated: true)
    }
}

extension FoodViewController: FoodViewModelDelegateProtocol {
    func didLoadedFood(foods: [FoodItem]) {
        self.foodList = foods
        self.isLoading = false
        self.collectionView.reloadData()
    }
    func didFailLoadedFood(title: String, error: String) {
        self.isLoading = false
        self.collectionView.reloadData()
        self.showAlertMessage(title: title, message: error)
    }
}
extension FoodViewController:UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func setUpSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Food..."
        searchController?.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController?.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
      
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        debouncer.run { [weak self] in
            DispatchQueue.main.async {
                self?.viewModel?.loadFood(searchText: searchText)
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchController.isActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchController.isActive = false
    }

}
