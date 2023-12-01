//  RatingStackView.swift
//  FakeNFT
//  Created by Georgy and Adam West on 06.11.2023.

import UIKit

class RatingStackView: UIStackView {
    // MARK: Public Properties
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    // MARK: Private properties
    private var ratingButtons = [UIButton]()
    
    // MARK: Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.spacing = 2
        translatesAutoresizingMaskIntoConstraints = false
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Methods
    private func setupButtons() {
        for _ in 0..<5 {
            let button = UIButton()
            button.setImage(UIImage(named: ImagesAssets.noStars.rawValue), for: .normal)
            button.setImage(UIImage(named: ImagesAssets.stars.rawValue), for: .selected)
            button.setImage(UIImage(named: ImagesAssets.stars.rawValue), for: [.highlighted, .selected])
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 12),
                button.widthAnchor.constraint(equalToConstant: 12)
            ])
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
