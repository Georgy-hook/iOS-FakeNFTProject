//  UIView.swift
//  FakeNFT
//  Created by Adam West on 03.11.2023.

import UIKit

extension UIView {
    // MARK: Multiple editing
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}

