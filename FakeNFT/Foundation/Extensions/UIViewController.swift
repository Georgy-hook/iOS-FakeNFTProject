//  UIViewController.swift
//  Profile
//  Created by Adam West on 03.11.2023.

import UIKit

extension UIViewController {
    // MARK: Hide keyboard when clicked
    var hideKeyboardWhenClicked: UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboardWhenClicked))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        return tap
    }
    @objc func dismissKeyboardWhenClicked() {
        view.endEditing(true)
    }
    
    // MARK: Show alert
    func showErrorLoadAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


