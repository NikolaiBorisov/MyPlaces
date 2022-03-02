//
//  MapViewModel.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 23.02.2022.
//

import Foundation
import MapKit

protocol MapViewModelProtocol {
    var identifier: String { get }
    var locationManager: CLLocationManager { get set }
    var regionInMeters: Double { get }
    var placeCoordinate: CLLocationCoordinate2D? { get set }
    var previousLocation: CLLocation? { get set }
    var mapView: MKMapView { get }
    var place: Place { get }
    var currentAddress: UILabel { get }
    var isAddressShown: Bool { get }
    var directionsArray: [MKDirections] { get }
    
    func setupLocationManager()
    func setupPlacemark()
    func setupMapViewImage(for annotationView: MKPinAnnotationView?)
    func checkLocationAuthorization(callBack: () -> Void?)
    func showUserLocation()
    func getCenterLocation() -> CLLocation
    func getCurrentAddress(with center: CLLocation)
    func getAnnotationView(using annotation: MKAnnotation) -> MKPinAnnotationView?
    func getDirections(callBack: @escaping (LocationAlertTitle, LocationAlertMessage) -> Void?)
    func startTrackingUserLocation()
    func resetMapView(with newDirections: MKDirections)
}

final class MapViewModel {
    
    var identifier: String { MapView.identifier }
    var locationManager = CLLocationManager()
    var regionInMeters: Double = 1000.00
    var placeCoordinate: CLLocationCoordinate2D?
    var mapView = MKMapView()
    var place = Place()
    var currentAddress = UILabel()
    var isAddressShown: Bool
    var directionsArray: [MKDirections] = []
    
    var previousLocation: CLLocation? {
        didSet {
            startTrackingUserLocation()
        }
    }
    
    init(
        mapView: MKMapView,
        place: Place,
        currentAddress: UILabel,
        isAddressShown: Bool
    ) {
        self.mapView = mapView
        self.place = place
        self.currentAddress = currentAddress
        self.isAddressShown = isAddressShown
    }
    
}

// MARK: - MapViewModelProtocol

extension MapViewModel: MapViewModelProtocol {
    
    func showUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(
                center: location,
                latitudinalMeters: regionInMeters,
                longitudinalMeters: regionInMeters
            )
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupMapViewImage(for annotationView: MKPinAnnotationView?) {
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
    }
    
    func setupPlacemark() {
        guard let location = place.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func checkLocationAuthorization(callBack: () -> Void?) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if isAddressShown { showUserLocation() }
            break
        case .denied:
            callBack()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is available!")
        }
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getCenterLocation() -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func getCurrentAddress(with center: CLLocation) {
        let geocoder = CLGeocoder()
        
        if !isAddressShown && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showUserLocation()
            }
        }
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildingNumber = placemark?.subThoroughfare
            DispatchQueue.main.async {
                if streetName != nil && buildingNumber != nil {
                    self.currentAddress.text = "\(streetName!), \(buildingNumber!)"
                } else if streetName != nil {
                    self.currentAddress.text = "\(streetName!)"
                } else {
                    self.currentAddress.text = ""
                }
            }
        }
    }
    
    func getAnnotationView(using annotation: MKAnnotation) -> MKPinAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        return annotationView
    }
    
    func getDirections(callBack: @escaping (LocationAlertTitle, LocationAlertMessage) -> Void?) {
        guard let location = locationManager.location?.coordinate else {
            callBack(.error, .locationNotFound)
            return
        }
        locationManager.startUpdatingLocation()
        previousLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        guard let request = createDirectionsRequest(from: location) else {
            callBack(.error, .destinationNotFound)
            return
        }
        let directions = MKDirections(request: request)
        resetMapView(with: directions)
        directions.calculate { (response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {
                callBack(.error, .directionNotAvailable)
                return
            }
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime
                print("Distance: \(distance) km.")
                print("Time: \(timeInterval) sec.")
            }
        }
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        return request
    }
    
    func startTrackingUserLocation() {
        guard let previousLocation = previousLocation else { return }
        let center = getCenterLocation()
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showUserLocation()
        }
    }
    
    func resetMapView(with newDirections: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(newDirections)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
}
