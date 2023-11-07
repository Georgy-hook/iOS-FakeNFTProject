//  FavouriteNFTCell.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import UIKit

final class FavouriteNFTCell: UICollectionViewCell & ReuseIdentifying {
    // MARK: Private properties
    let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    var isLiked = true
    let ratingStar = RatingStackView()
    let nameLabel = MyNFTLabel(labelType: .big, text: nil)
    let priceLabel = MyNFTLabel(labelType: .middle, text: nil)
    
    // MARK: Public Properties
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: ImagesAssets.like.rawValue), for: .normal)
        button.addTarget(self, action: #selector(addLike), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    @objc func addLike() {
        if isLiked {
            likeButton.setImage(UIImage(named: ImagesAssets.noLike.rawValue), for: .normal)
            isLiked = false
        } else {
            likeButton.setImage(UIImage(named: ImagesAssets.like.rawValue), for: .normal)
            isLiked = true
        }
        
    }
}

// MARK: - Setup views, constraints
private extension FavouriteNFTCell {
    func setupUI() {
        contentView.addSubviews(nftImageView, likeButton, ratingStar, nameLabel, priceLabel)
                
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            
            
            ratingStar.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStar.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            
            priceLabel.topAnchor.constraint(equalTo: ratingStar.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
        ])
    }
}

