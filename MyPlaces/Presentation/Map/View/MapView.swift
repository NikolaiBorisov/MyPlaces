//
//  MapView.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 23.02.2022.
//

import Foundation
import MapKit

final class MapView: UIView {
    
    // MARK: - Public Properties
    
    public var locationButtonTapped: (() -> Void)?
    public var doneButtonTapped: (() -> Void)?
    public var directionButtonTapped: (() -> Void)?
    
    public lazy var mapView: MKMapView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(MKMapView())
    
    public var locationMarkerImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = AppImage.pin
        return $0
    }(UIImageView())
    
    public let currentAddressLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = AppLabel.loading
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        return $0
    }(UILabel())
    
    public lazy var doneButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(AppLabel.done, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        return $0
    }(UIButton(type: .system))
    
    public lazy var directionButton: UIButton = {
        $0.setImage(AppImage.direction?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.clipsToBounds = true
        $0.isHidden = true
        return $0
    }(UIButton(type: .system))
    
    // MARK: - Private Properties
    
    private lazy var locationButton: UIButton = {
        $0.setImage(AppImage.userLocation?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.clipsToBounds = true
        return $0
    }(UIButton(type: .system))
    
    private lazy var locationStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [directionButton, locationButton]))
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupLayout()
        setupView()
        addActionForButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func buttonWasTapped(sender: UIButton) {
        switch sender {
        case locationButton: locationButtonTapped?()
        case doneButton: doneButtonTapped?()
        case directionButton: directionButtonTapped?()
        default: break
        }
    }
    
    // MARK: - Private Methods
    
    private func addActionForButton() {
        [locationButton, doneButton, directionButton].forEach {
            $0.addTarget(self, action: #selector(buttonWasTapped), for: .touchUpInside)
        }
    }
    
    private func setupView() {
        backgroundColor = .green
        doneButton.roundWith(radius: 10, borderColor: .white, borderWidth: 2)
    }
    
    private func addSubviews() {
        addSubview(mapView)
        addSubview(locationStackView)
        mapView.addSubview(locationMarkerImageView)
        mapView.addSubview(currentAddressLabel)
        mapView.addSubview(doneButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            locationMarkerImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            locationMarkerImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -20),
            locationMarkerImageView.heightAnchor.constraint(equalToConstant: 40),
            locationMarkerImageView.widthAnchor.constraint(equalToConstant: 40),
            
            currentAddressLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            currentAddressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            currentAddressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            doneButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            locationStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            locationStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            directionButton.heightAnchor.constraint(equalToConstant: 60),
            directionButton.widthAnchor.constraint(equalToConstant: 60),
            
            locationButton.heightAnchor.constraint(equalToConstant: 50),
            locationButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
