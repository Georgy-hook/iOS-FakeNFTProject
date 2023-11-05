//  MyNFTCell.swift
//  FakeNFT
//  Created by Adam West on 04.11.2023.

import UIKit

final class MyNFTCell: UITableViewCell & ReuseIdentifying {
    // MARK: Public Properties
    static let identifier = "MyNFTCell"
    
    // MARK: Private properties
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NFT card 1")
        return imageView
    }()
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: ImagesAssets.noLike.rawValue), for: .normal)
        button.addTarget(self, action: #selector(addLike), for: .touchUpInside)
        return button
    }()
    private let ratingStarOne = MyNFTStarImage(myNFTStarType: .star)
    private let ratingStarTwo = MyNFTStarImage(myNFTStarType: .star)
    private let ratingStarThree = MyNFTStarImage(myNFTStarType: .star)
    private let ratingStarFour = MyNFTStarImage(myNFTStarType: .noStar)
    private let ratingStarFive = MyNFTStarImage(myNFTStarType: .noStar)

    
    private let nameLabel = MyNFTLabel(labelType: .big, text: "Adam West")
    private let fromAuthorLabel = MyNFTLabel(labelType: .middle, text: "от")
    private let authorLabel = MyNFTLabel(labelType: .little, text: "Artur Doile")
    private let namePriceLabel = MyNFTLabel(labelType: .little, text: "Цена")
    private let priceLabel = MyNFTLabel(labelType: .big, text: "6,99 ETH")
    
    // MARK: Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    @objc private func addLike() {
        #warning("TODO")
        likeButton.setImage(UIImage(named: ImagesAssets.like.rawValue), for: .focused)
    }
}

// MARK: - Setup views, constraints
private extension MyNFTCell {
    func setupUI() {
        contentView.addSubviews(nftImageView, likeButton,
        ratingStarOne, ratingStarTwo, ratingStarThree, ratingStarFour, ratingStarFive,                            nameLabel, fromAuthorLabel, authorLabel,
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
            
            ratingStarOne.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStarOne.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            ratingStarTwo.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStarTwo.leadingAnchor.constraint(equalTo: ratingStarOne.trailingAnchor, constant: 2),
            
            ratingStarThree.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStarThree.leadingAnchor.constraint(equalTo: ratingStarTwo.trailingAnchor, constant: 2),
            
            ratingStarFour.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStarFour.leadingAnchor.constraint(equalTo: ratingStarThree.trailingAnchor, constant: 2),
            
            ratingStarFive.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStarFive.leadingAnchor.constraint(equalTo: ratingStarFour.trailingAnchor, constant: 2),
            
            fromAuthorLabel.topAnchor.constraint(equalTo: ratingStarOne.bottomAnchor, constant: 4),
            fromAuthorLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            fromAuthorLabel.widthAnchor.constraint(equalToConstant: 16),
            
            authorLabel.topAnchor.constraint(equalTo: ratingStarOne.bottomAnchor, constant: 6),
            authorLabel.leadingAnchor.constraint(equalTo: fromAuthorLabel.trailingAnchor, constant: 4),
            
            namePriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30 + 16),
            namePriceLabel.leadingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: namePriceLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(lessThanOrEqualTo: authorLabel.trailingAnchor, constant: 39),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
