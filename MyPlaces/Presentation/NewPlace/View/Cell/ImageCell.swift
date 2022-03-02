//
//  ImageCell.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 18.02.2022.
//

import UIKit

protocol ImageCellDelegate: AnyObject {
    func showLocation()
}

final class ImageCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    public weak var delegate: ImageCellDelegate?
    
    public var imageCell: NewPlaceCellType? {
        didSet {
            configure()
        }
    }
    
    public lazy var placeImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    // MARK: - Private Properties
    
    private lazy var mapButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(AppImage.map?.withRenderingMode(.alwaysOriginal), for: .normal)
        return $0
    }(UIButton(type: .system))
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        setupLayout()
        addActionForButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Actions
    
    @objc private func mapButtonWasTapped() {
        delegate?.showLocation()
    }
    
    // MARK: - Public Methods
    
    public func configureForEditing(
        with item: Place?,
        newImage: UIImageView,
        isEditing: Bool
    ) {
        if isEditing, item != nil {
            guard let data = item?.imageData,
                  let image = UIImage(data: data) else { return }
            placeImageView.image = image
        } else {
            placeImageView.image = newImage.image
        }
    }
    
    // MARK: - Private Methods
    
    private func addActionForButton() {
        mapButton.addTarget(self, action: #selector(mapButtonWasTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        contentView.addSubview(placeImageView)
        contentView.addSubview(mapButton)
        contentView.bringSubviewToFront(mapButton)
    }
    
    private func setupView() {
        contentView.superview?.backgroundColor = .white
        selectionStyle = .none
        mapButton.setShadowWith()
    }
    
    private func configure() {
        guard let newPlaceImageCell = imageCell else { return }
        placeImageView.image = UIImage(named: newPlaceImageCell.currentImage)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            placeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            placeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            placeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            placeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            mapButton.heightAnchor.constraint(equalToConstant: 30),
            mapButton.widthAnchor.constraint(equalToConstant: 30),
            mapButton.trailingAnchor.constraint(equalTo: placeImageView.trailingAnchor),
            mapButton.bottomAnchor.constraint(equalTo: placeImageView.bottomAnchor, constant: -5),
        ])
    }
    
}
