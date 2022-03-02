//
//  MainViewController.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 14.02.2022.
//

import UIKit
import RealmSwift

final class MainViewController: UIViewController, SearchControllerProtocol {
    
    // MARK: - Private Properties
    
    private lazy var mainView = MainView(delegate: self)
    private var viewModel: PlacesViewModelProtocol!
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private let coordinator: MainCoordinator
    
    // MARK: - Initializers
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupView()
        setupNavBar()
        setupCallback()
    }
    
    // MARK: - Actions
    
    @objc private func onNavItemTapped(sender: UIBarButtonItem) {
        let rightButton = navigationItem.rightBarButtonItem
        let leftButton = navigationItem.leftBarButtonItem
        switch sender {
        case rightButton:
            let vc = NewPlaceViewController(coordinator: coordinator, delegate: self)
            // TODO: - FixMe
            // coordinator.pushNewPlaceScreen(delegate: self)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case leftButton:
            viewModel.ascendingSorting.toggle()
            leftButton?.image = viewModel.ascendingSorting ? AppImage.ascSort : AppImage.descSort
            viewModel.sorting(places: &places, keyPath: nil) {
                self.mainView.placesTableView.reloadData()
            }
        default: break
        }
        
    }
    
    // MARK: - Private Methods
    
    public func setupCallback() {
        mainView.refreshControlPulled = { [weak self] in
            guard let self = self else { return }
            self.fetchData()
        }
    }
    
    private func fetchData() {
        mainView.activityIndicator.startAnimating()
        places = StorageManager.shared.realm.objects(Place.self)
        mainView.activityIndicator.stopAnimating()
    }
    
    private func setupView() {
        viewModel = PlacesViewModelImpl(index: mainView.segmentedControl.selectedSegmentIndex)
        mainView.placesTableView.delegate = self
        mainView.placesTableView.dataSource = self
        setup(searchController: viewModel.searchController)
    }
    
    private func setupNavBar() {
        setupNavBar(withTitle: AppLabel.myPlaces)
        navigationItem.rightBarButtonItem = .setupNavItem(
            with: self,
            action: #selector(onNavItemTapped),
            icon: AppImage.plus,
            color: .systemBlue
        )
        navigationItem.leftBarButtonItem = .setupNavItem(
            with: self,
            action: #selector(onNavItemTapped),
            icon: AppImage.ascSort,
            color: .systemBlue
        )
    }
    
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.isFiltering ? filteredPlaces.count : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceCell = tableView.dequeueCell(for: indexPath)
        let place = viewModel.isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
        cell.configure(with: place)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = viewModel.isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
        let vc = NewPlaceViewController(coordinator: coordinator, delegate: self)
        vc.currentPlace = place
        vc.isPlaceEditing = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  _, _, _ in
            let place = self.places[indexPath.row]
            StorageManager.shared.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

// MARK: - NewPlaceViewControllerDelegate

extension MainViewController: NewPlaceViewControllerDelegate {
    
    func updateData() {
        DispatchQueue.main.async {
            self.mainView.placesTableView.reloadData()
        }
    }
    
}

// MARK: - MainViewDelegate

extension MainViewController: MainViewDelegate {
    
    func sorted(by keyPath: String) {
        viewModel.sorting(places: &places, keyPath: keyPath) {
            self.mainView.placesTableView.reloadData()
        }
    }
    
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredPlaces = places.filter(AppPredicate.searchPredicate, searchText, searchText)
        DispatchQueue.main.async {
            self.mainView.placesTableView.reloadData()
        }
    }
    
}
