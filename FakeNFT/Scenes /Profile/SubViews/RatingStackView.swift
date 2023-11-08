//
//  RatingStackView.swift
//  FakeNFT
//
//  Created by Georgy on 06.11.2023.
//

import UIKit

class RatingStackView: UIStackView {
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        for _ in 0..<5 {
            let button = UIButton()
            button.setImage(UIImage(named: ImagesAssets.noStars.rawValue), for: .normal)
            button.setImage(UIImage(named: ImagesAssets.stars.rawValue), for: .selected)
            button.setImage(UIImage(named: ImagesAssets.stars.rawValue), for: [.highlighted, .selected])
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 12).isActive = true
            button.widthAnchor.constraint(equalToConstant: 12).isActive = true
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
