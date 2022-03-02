//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 15.02.2022.
//

import UIKit

protocol NewPlaceViewControllerDelegate: AnyObject {
    func updateData()
}

final class NewPlaceViewController: UIViewController, LoadableImagePickerAlertController {
    
    // MARK: - Public Properties
    
    public weak var delegate: NewPlaceViewControllerDelegate?
    public var currentPlace: Place?
    public var viewModel: NewPlaceViewModelProtocol!
    public var isGettingCurrentAddress = false
    public var isPlaceEditing = false
    
    // MARK: - Private Properties
    
    private lazy var mainView = NewPlaceView()
    private let model: NewPlaceScreenProtocol = NewPlaceScreenModelImpl()
    private lazy var realm = StorageManager.shared
    private var coordinator: MainCoordinator
    
    // MARK: - Initializers
    
    init(coordinator: MainCoordinator, delegate: NewPlaceViewControllerDelegate?) {
        self.coordinator = coordinator
        self.delegate = delegate
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
        
        setupView()
        setupNavBar()
        setupEditScreen()
        setupNewImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainView.removeKeyboardObservers()
    }
    
    // MARK: - Actions
    
    @objc private func onSaveButtonTapped(sender: UIBarButtonItem) {
        viewModel.savePlace()
        delegate?.updateData()
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupNewImage() {
        viewModel.setupNewImage()
    }
    
    private func setupView() {
        viewModel = NewPlaceViewModel(isEditing: isPlaceEditing, currentPlace: currentPlace)
        mainView.newPlaceTableView.delegate = self
        mainView.newPlaceTableView.dataSource = self
    }
    
    private func setupNavBar() {
        title = AppLabel.newPlace
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = .setupNavItem(
            with: self,
            action: #selector(onSaveButtonTapped),
            title: AppLabel.save,
            color: .systemBlue
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupNavBarWhileEditing() {
        if currentPlace != nil {
            title = currentPlace?.name
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    private func setupEditScreen() {
        viewModel.setupNewPlaceEditScreen{ setupNavBarWhileEditing() }
    }
    
}

// MARK: - UITableViewDataSource

extension NewPlaceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.cellsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cellsData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = model.cellsData[indexPath.section][indexPath.row]
        switch data {
        case .onlyImage:
            let cell: ImageCell = tableView.dequeueCell(for: indexPath)
            cell.imageCell = data
            cell.delegate = self
            if viewModel.isEditing {
                cell.configureForEditing(
                    with: currentPlace,
                    newImage: viewModel.newImage,
                    isEditing: true
                )
            } else {
                cell.placeImageView.image = viewModel.newImage.image
            }
            return cell
        case .onlyText:
            switch indexPath.row {
            case 0:
                let cell: TitleCell = tableView.dequeueCell(for: indexPath)
                cell.delegate = self
                cell.titleTextField.delegate = self
                cell.titleCell = data
                cell.isSaveButtonEnabled = { self.navigationItem.rightBarButtonItem?.isEnabled = $0 }
                if viewModel.isEditing { cell.configureForEditing(with: currentPlace) }
                return cell
            case 1:
                let cell: LocationCell = tableView.dequeueCell(for: indexPath)
                cell.locationCell = data
                cell.locationTextField.delegate = self
                cell.delegate = self
                if viewModel.isEditing { cell.configureForEditing(with: currentPlace) }
                if isGettingCurrentAddress { cell.locationTextField.text = viewModel.newLocation }
                return cell
            case 2:
                let cell: TypeCell = tableView.dequeueCell(for: indexPath)
                cell.typeCell = data
                cell.typeTextField.delegate = self
                cell.delegate = self
                if viewModel.isEditing { cell.configureForEditing(with: currentPlace) }
                return cell
            default: return UITableViewCell()
            }
        case .rating:
            let cell: RatingCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self
            if viewModel.isEditing { cell.configureForEditing(with: currentPlace) }
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate

extension NewPlaceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = model.cellsData[indexPath.section][indexPath.row]
        switch data {
        case .onlyImage: return 250
        case .onlyText: return 80
        case .rating: return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = model.cellsData[indexPath.section][indexPath.row]
        switch data {
        case .onlyImage:
            showActionSheet() {
                self.chooseImagePicker(source: .camera)
            } completionPhoto: {
                self.chooseImagePicker(source: .photoLibrary)
            }
        case .onlyText: view.endEditing(true)
        case .rating: view.endEditing(true)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension NewPlaceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - NewPlaceViewController

extension NewPlaceViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerFactory.generate(withSource: source)
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        viewModel.setupPickedImage(with: info) {
            mainView.newPlaceTableView.reloadData()
        }
        dismiss(animated: true)
    }
    
}

// MARK: - ImageCellDelegate

extension NewPlaceViewController: ImageCellDelegate {
    
    func showLocation() {
        let vc = MapViewController(coordinator: coordinator)
        if !vc.isAddressShown {
            vc.place.name = viewModel.newTitle
            vc.place.location = viewModel.newLocation
            vc.place.type = viewModel.newType
            vc.place.imageData = viewModel.newImage.image?.pngData()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: - TitleCellDelegate

extension NewPlaceViewController: TitleCellDelegate {
    
    func send(newTitle: String) { viewModel.newTitle = newTitle }
    
}

// MARK: - LocationCellDelegate

extension NewPlaceViewController: LocationCellDelegate {
    
    func showAddress() {
        let vc = MapViewController(coordinator: coordinator)
        vc.isAddressShown = true
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func send(newLocation: String) { viewModel.newLocation = newLocation }
    
}

// MARK: - TypeCellDelegate

extension NewPlaceViewController: TypeCellDelegate {
    
    func send(newType: String) { viewModel.newType = newType }
    
}

// MARK: - RatingCellDelegate

extension NewPlaceViewController: RatingCellDelegate {
    
    func rating(count: Int) { viewModel.rating = count }
    
}

// MARK: - MapViewControllerDelegate

extension NewPlaceViewController: MapViewControllerDelegate {
    
    func getAddress(_ address: String?) {
        isGettingCurrentAddress = true
        viewModel.newLocation = address
        mainView.newPlaceTableView.reloadData()
    }
    
}
