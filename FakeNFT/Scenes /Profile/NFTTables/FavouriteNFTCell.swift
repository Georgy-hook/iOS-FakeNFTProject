//  FavouriteNFTCell.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import UIKit
import Kingfisher

protocol InterfaceFavouriteNFTCell: AnyObject {
    var delegate: FavouriteNFTViewController? { get set }
}

final class FavouriteNFTCell: UICollectionViewCell & ReuseIdentifying, InterfaceFavouriteNFTCell {
    // MARK: UI
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: ImagesAssets.like.rawValue), for: .normal)
        button.addTarget(self, action: #selector(checkButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    // MARK: Delegate
    weak var delegate: FavouriteNFTViewController?
    
    // MARK: Private Properties
    private let ratingStar = RatingStackView()
    private let nameLabel = MyNFTLabel(labelType: .big, text: nil)
    private let priceLabel = MyNFTLabel(labelType: .middle, text: nil)
    
    // MARK: Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func configure(with nft: Nft) {
        if let image = nft.images.first {
            nftImageView.kf.indicatorType = .activity
            nftImageView.kf.setImage(with: image)
        }
        nameLabel.text = nft.name
        ratingStar.rating = nft.rating
        priceLabel.text = String(nft.price)
    }
    
    private func deleteCell(sender: UIButton) {
        if let cell = sender.superview?.superview as? UICollectionViewCell, let indexPath = delegate?.collectionView.indexPath(for: cell) {
            delegate?.presenter.removeFromCollection(indexPath.row)
            delegate?.collectionView.deleteItems(at: [indexPath])
            delegate?.reloadData()
        }
    }
    
    // MARK: Selectors
    @objc func checkButtonTapped(sender : UIButton){
        deleteCell(sender: sender)
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
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12)
        ])
    }
}

