//
//  RatingCell.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 22.02.2022.
//

import UIKit

protocol RatingCellDelegate: AnyObject {
    func rating(count: Int)
}

final class RatingCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    public weak var delegate: RatingCellDelegate?
    
    // MARK: - Private Properties
    
    private lazy var ratingContainer: RatingControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(RatingControl(starSize: CGSize(width: 40, height: 40)))
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public Methods
    
    public func configureForEditing(with item: Place?) {
        if item != nil {
            ratingContainer.rating = Int(item?.rating ?? 0)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupDelegate() {
        ratingContainer.delegate = self
    }
    
    private func setupView() {
        contentView.superview?.backgroundColor = .white
        selectionStyle = .none
    }
    
    private func addSubviews() {
        contentView.addSubview(ratingContainer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            ratingContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ratingContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}

// MARK: - RatingControlDelegate

extension RatingCell: RatingControlDelegate {
    
    func sendRating(count: Int) {
        delegate?.rating(count: count)
    }
    
}
