//
//  NewPlaceView.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 15.02.2022.
//

import UIKit

final class NewPlaceView: UIView {
    
    // MARK: - Public Properties
    
    public lazy var newPlaceTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.register(cell: ImageCell.self)
        $0.register(cell: TitleCell.self)
        $0.register(cell: LocationCell.self)
        $0.register(cell: TypeCell.self)
        $0.register(cell: RatingCell.self)
        $0.contentInsetAdjustmentBehavior = .never
        $0.separatorColor = .lightGray
        $0.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        $0.backgroundColor = .white
        return $0
    }(UITableView())
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func setupKeyboardObservers() {
        newPlaceTableView.setupKeyboardObservers()
    }
    
    public func removeKeyboardObservers() {
        newPlaceTableView.removeKeyboardObservers()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(newPlaceTableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            newPlaceTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            newPlaceTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newPlaceTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newPlaceTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
}
