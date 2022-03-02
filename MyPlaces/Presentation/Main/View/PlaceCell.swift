//
//  PlaceCell.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 14.02.2022.
//

import UIKit

final class PlaceCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    public var placeImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    public lazy var placeTitleLabel = UILabelFactory.generate(withFontSize: 18, textColor: .black)
    public lazy var placeLocationLabel = UILabelFactory.generate(withFontSize: 16, textColor: .lightGray)
    public lazy var placeTypeLabel = UILabelFactory.generate(withFontSize: 16, textColor: .lightGray)
    
    // MARK: - Private Properties
    
    private var imageWidth: CGFloat = 70
    
    private lazy var ratingContainer: RatingControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(RatingControl(starSize: CGSize(width: 20, height: 20)))
    
    private lazy var labelStackView = UIStackViewFactory.generate(
        with: [placeTitleLabel, placeLocationLabel, placeTypeLabel],
        axis: .vertical,
        distribution: .fillProportionally
    )
    
    private lazy var mainStackView = UIStackViewFactory.generate(
        with: [placeImageView, labelStackView],
        axis: .horizontal,
        distribution: .fillProportionally
    )
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupImageView()
    }
    
    // MARK: - Public Methods
    
    public func configure(with item: Place) {
        placeTitleLabel.text = item.name
        placeLocationLabel.text = item.location
        placeTypeLabel.text = item.type
        ratingContainer.rating = Int(item.rating)
        let imageDataDefault = AppImage.imgPlaceholder.pngData()!
        placeImageView.image = UIImage(data: item.imageData ?? imageDataDefault)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentView.superview?.backgroundColor = .white
        selectionStyle = .none
        ratingContainer.isUserInteractionEnabled = false
    }
    
    private func addSubviews() {
        contentView.addSubview(mainStackView)
        contentView.addSubview(ratingContainer)
    }
    
    private func setupImageView() {
        placeImageView.roundWith(radius: imageWidth / 2, borderColor: UIColor.lightGray, borderWidth: 2)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.bottomAnchor.constraint(equalTo: ratingContainer.topAnchor, constant: -5),
            
            ratingContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            ratingContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            placeImageView.widthAnchor.constraint(equalToConstant: imageWidth)
        ])
    }
    
}
