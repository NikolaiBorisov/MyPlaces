//
//  RatingControl.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 22.02.2022.
//

import UIKit

protocol RatingControlDelegate: AnyObject {
    func sendRating(count: Int)
}

final class RatingControl: UIStackView {
    
    // MARK: - Public Properties
    
    public weak var delegate: RatingControlDelegate?
    
    public var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    // MARK: - Private Properties
    
    private var ratingButtons = [UIButton]()
    private var starSize = CGSize(width: 0, height: 0) {
        didSet {
            setupButtons()
        }
    }
    private var starCount = 5 {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: - Initializers
    
    init(starSize: CGSize) {
        self.starSize = starSize
        super.init(frame: .zero)
        
        setupView()
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func onButtonTapped(sender: UIButton) {
        guard let index = ratingButtons.firstIndex(of: sender) else { return }
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        delegate?.sendRating(count: selectedRating)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        spacing = 10
        distribution = .fillEqually
    }
    
    private func addSubviews(view: UIView) {
        addArrangedSubview(view)
    }
    
    private func setupButtonAction(for button: UIButton) {
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }
    
    private func setupButtons() {
        updateButtonsQuantity()
        for _ in 0..<starCount {
            let button = UIButton()
            setButtonImage(for: button)
            setupButtonAction(for: button)
            setupLayout(for: button)
            addSubviews(view: button)
            ratingButtons.append(button)
        }
        updateButtonSelectionState()
    }
    
    private func setButtonImage(for button: UIButton) {
        let emptyStar = AppImage.emptyStar
        let filledStar = AppImage.filledStar
        let goldStar = AppImage.goldStar
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(emptyStar, for: .normal)
        button.setImage(goldStar, for: .selected)
        button.setImage(filledStar, for: .highlighted)
        button.setImage(filledStar, for: [.highlighted, .selected])
    }
    
    private func updateButtonsQuantity() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    private func setupLayout(for view: UIView) {
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: starSize.width),
            view.heightAnchor.constraint(equalToConstant: starSize.height)
        ])
    }
    
}
