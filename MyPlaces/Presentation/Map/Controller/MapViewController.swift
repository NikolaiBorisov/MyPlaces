//
//  MapViewController.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 23.02.2022.
//

import UIKit
import CoreLocation
import MapKit

protocol MapViewControllerDelegate: AnyObject {
    func getAddress(_ address: String?)
}

final class MapViewController: UIViewController, LoadableLocationAlertController {
    
    // MARK: - Public Properties
    
    public var place = Place()
    public var isAddressShown = false
    public weak var delegate: MapViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private lazy var mainView = MapView()
    private var viewModel: MapViewModelProtocol!
    private var coordinator: MainCoordinator
    
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
        
        setupView()
        setupMapView()
        setupDelegate()
        checkLocationServices()
        setupCallback()
    }
    
    // MARK: - Private Methods
    
    private func setupCallback() {
        mainView.locationButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.showUserLocation()
        }
        mainView.doneButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.delegate?.getAddress(self.mainView.currentAddressLabel.text)
            self.navigationController?.popViewController(animated: true)
        }
        mainView.directionButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getDirections { (title, message) in
                self.showAlertWith(title: title, message: message)
            }
        }
    }
    
    private func setupView() {
        viewModel = MapViewModel(
            mapView: mainView.mapView,
            place: place,
            currentAddress: mainView.currentAddressLabel,
            isAddressShown: isAddressShown
        )
    }
    
    private func setupDelegate() {
        mainView.mapView.delegate = self
        viewModel.locationManager.delegate = self
    }
    
    private func setupMapView() {
        if !isAddressShown {
            setupPlacemark()
            mainView.locationMarkerImageView.isHidden = true
            mainView.doneButton.isHidden = true
            mainView.currentAddressLabel.isHidden = true
            mainView.directionButton.isHidden = false
        }
    }
    
    private func setupPlacemark() {
        viewModel.setupPlacemark()
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            viewModel.setupLocationManager()
            viewModel.checkLocationAuthorization {
                showAlertWith(title: .locationNotAvailable, message: .givePermission)
            }
        } else {
            showAlertWith(title: .locationServicesDisabled, message: .enable)
        }
    }
    
    private func showAlertWith(title: LocationAlertTitle, message: LocationAlertMessage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAlert(title: title, message: message)
        }
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = viewModel.getAnnotationView(using: annotation)
        viewModel.setupMapViewImage(for: annotationView)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = viewModel.getCenterLocation()
        viewModel.getCurrentAddress(with: center)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
    
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        viewModel.checkLocationAuthorization {
            showAlert(title: .locationNotAvailable, message: .enable)
        }
    }
    
}
