//  MyNFTCell.swift
//  FakeNFT
//  Created by Adam West on 04.11.2023.

import UIKit
import Kingfisher

final class MyNFTCell: UITableViewCell & ReuseIdentifying {
    // MARK: Public properties
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: ImagesAssets.noLike.rawValue), for: .normal)
        button.setImage(UIImage(named: ImagesAssets.like.rawValue), for: .selected)
        button.setImage(UIImage(named: ImagesAssets.like.rawValue), for: [.highlighted, .selected])
        return button
    }()
    
    // MARK: Private properties
    private var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    private var nameLabel = MyNFTLabel(labelType: .big, text: nil)
    private var ratingStar = RatingStackView()
    private var authorLabel = MyNFTLabel(labelType: .little, text: nil)
    private var priceLabel = MyNFTLabel(labelType: .big, text: nil)
    
    private let fromAuthorLabel = MyNFTLabel(labelType: .middle, text: "от")
    private let namePriceLabel = MyNFTLabel(labelType: .little, text: "Цена")
    
    // MARK: Initialisation
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func configure(with nft: Nft, user: User) {
        if let image = nft.images.first {
            nftImageView.kf.indicatorType = .activity
            nftImageView.kf.setImage(with: image)
        }
        nameLabel.text = nft.name
        ratingStar.rating = nft.rating
        authorLabel.text = user.name
        priceLabel.text = "\(nft.price) ETH"
    }
}

// MARK: - Setup views, constraints
private extension MyNFTCell {
    func setupUI() {
        contentView.addSubviews(nftImageView, likeButton, ratingStar,
                                nameLabel, fromAuthorLabel, authorLabel,
                                namePriceLabel, priceLabel)
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23 + 16),
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            ratingStar.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStar.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),

            fromAuthorLabel.topAnchor.constraint(equalTo: ratingStar.bottomAnchor, constant: 4),
            fromAuthorLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            fromAuthorLabel.widthAnchor.constraint(equalToConstant: 16),
            
            authorLabel.topAnchor.constraint(equalTo: ratingStar.bottomAnchor, constant: 6),
            authorLabel.leadingAnchor.constraint(equalTo: fromAuthorLabel.trailingAnchor, constant: 4),
            
            namePriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30 + 16),
            namePriceLabel.leadingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: namePriceLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(lessThanOrEqualTo: ratingStar.trailingAnchor, constant: 39 + 12),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
