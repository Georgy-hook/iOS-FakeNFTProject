//  UIViewController.swift
//  FakeNFT
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
    func showErrorLoadAlert(_ completion: @escaping() -> Void) {
        let alert = UIAlertController(title: "Не удалось получить данные", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { [weak self] _ in
            self?.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            completion()
        }
        alert.addAction(cancelAction)
        alert.addAction(repeatAction)
        self.present(alert, animated: true, completion: nil)
    }
}


