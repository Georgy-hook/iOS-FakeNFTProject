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
}


