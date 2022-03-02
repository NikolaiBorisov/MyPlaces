//
//  TypeCell.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 18.02.2022.
//

import UIKit

protocol TypeCellDelegate: AnyObject {
    func send(newType: String)
}

final class TypeCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    public weak var delegate: TypeCellDelegate?
    
    public var typeCell: NewPlaceCellType? {
        didSet { configure() }
    }
    
    public lazy var typeTextField = UITextFieldFactory.generate()
    
    // MARK: - Private Properties
    
    private lazy var placeLabel = UILabelFactory.generate(withFontSize: 20)
    private lazy var typeStackView = UIStackViewFactory.generate(
        with: [placeLabel, typeTextField], axis: .vertical, distribution: .fillEqually
    )
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        setupLayout()
        addActionForTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange(sender: UITextField) {
        delegate?.send(newType: sender.text ?? AppLabel.type)
    }
    
    // MARK: - Public Methods
    
    public func configureForEditing(with item: Place?) {
        if item != nil {
            typeTextField.text = item?.type
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentView.superview?.backgroundColor = .white
        selectionStyle = .none
    }
    
    private func addSubviews() {
        contentView.addSubview(typeStackView)
    }
    
    private func addActionForTextField() {
        typeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    private func configure() {
        guard let newPlaceTypeCell = typeCell else { return }
        placeLabel.text = newPlaceTypeCell.currentLabelText
        typeTextField.placeholder = newPlaceTypeCell.currentTextFieldText
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            typeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            typeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            typeStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            typeStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
}
