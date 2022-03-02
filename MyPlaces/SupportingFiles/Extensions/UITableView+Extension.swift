//
//  UITableView+Extension.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 14.02.2022.
//

import UIKit
import MapKit

// MARK: - Register and DequeueCell for UITableViewCell

extension UITableView {
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
}

// MARK: - KeyboardObservers

extension UITableView {
    
    // MARK: - Actions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.contentInset = contentInsets
    }
    
    // MARK: - Public Methods
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
}
