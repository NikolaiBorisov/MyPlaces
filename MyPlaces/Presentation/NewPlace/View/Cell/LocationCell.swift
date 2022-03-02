//
//  LocationCell.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 18.02.2022.
//

import UIKit

protocol LocationCellDelegate: AnyObject {
    func send(newLocation: String)
    func showAddress()
}

final class LocationCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    public weak var delegate: LocationCellDelegate?
    
    public var locationCell: NewPlaceCellType? {
        didSet { configure() }
    }
    
    public lazy var locationTextField = UITextFieldFactory.generate()
    
    // MARK: - Private Properties
    
    private lazy var placeLabel = UILabelFactory.generate(withFontSize: 20)
    private lazy var locationStackView = UIStackViewFactory.generate(
        with: [placeLabel, locationTextField], axis: .vertical, distribution: .fillEqually
    )
    
    private lazy var mapButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(AppImage.locationMap?.withRenderingMode(.alwaysOriginal), for: .normal)
        return $0
    }(UIButton(type: .system))
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        setupLayout()
        addActionForTextField()
        addActionForButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange(sender: UITextField) {
        delegate?.send(newLocation: sender.text ?? AppLabel.location)
    }
    
    @objc private func mapButtonWasTapped() {
        delegate?.showAddress()
    }
    
    // MARK: - Public Methods
    
    public func configureForEditing(with item: Place?) {
        if item != nil {
            locationTextField.text = item?.location
        }
    }
    
    // MARK: - Private Methods
    
    private func addActionForButton() {
        mapButton.addTarget(self, action: #selector(mapButtonWasTapped), for: .touchUpInside)
    }
    
    private func setupView() {
        contentView.superview?.backgroundColor = .white
        selectionStyle = .none
        mapButton.setShadowWith(color: .lightGray)
    }
    
    private func addSubviews() {
        contentView.addSubview(locationStackView)
        contentView.addSubview(mapButton)
    }
    
    private func addActionForTextField() {
        locationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    private func configure() {
        guard let newPlaceLocationCell = locationCell else { return }
        placeLabel.text = newPlaceLocationCell.currentLabelText
        locationTextField.placeholder = newPlaceLocationCell.currentTextFieldText
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            locationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationStackView.trailingAnchor.constraint(equalTo: mapButton.leadingAnchor, constant: -5),
            locationStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            locationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            mapButton.heightAnchor.constraint(equalToConstant: 50),
            mapButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            mapButton.widthAnchor.constraint(equalToConstant: 50),
            mapButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
