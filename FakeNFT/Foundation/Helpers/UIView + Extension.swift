//
//  UIView + Extension.swift
//  FakeNFT
//
//  Created by Руслан  on 04.11.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
