//
//  TitleCell.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 15.02.2022.
//

import UIKit

protocol TitleCellDelegate: AnyObject {
    func send(newTitle: String)
}

final class TitleCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    public var isSaveButtonEnabled: ((Bool) -> Void)?
    public weak var delegate: TitleCellDelegate?
    
    public var titleCell: NewPlaceCellType? {
        didSet { configure() }
    }
    
    public lazy var titleTextField = UITextFieldFactory.generate()
    
    // MARK: - Private Properties
    
    private lazy var titleLabel = UILabelFactory.generate(withFontSize: 20, textColor: .lightGray)
    private lazy var titleStackView = UIStackViewFactory.generate(
        with: [titleLabel, titleTextField], axis: .vertical, distribution: .fillEqually
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
        guard let title = sender.text, !title.isEmpty else {
            isSaveButtonEnabled?(false)
            return
        }
        isSaveButtonEnabled?(true)
        delegate?.send(newTitle: title)
    }
    
    // MARK: - Public Methods
    
    public func configureForEditing(with item: Place?) {
        if item != nil {
            titleTextField.text = item?.name
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentView.superview?.backgroundColor = .white
        selectionStyle = .none
    }
    
    private func addSubviews() {
        contentView.addSubview(titleStackView)
    }
    
    private func addActionForTextField() {
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    private func configure() {
        guard let newPlaceTitleCell = titleCell else { return }
        titleLabel.text = newPlaceTitleCell.currentLabelText
        titleTextField.placeholder = newPlaceTitleCell.currentTextFieldText
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
}
