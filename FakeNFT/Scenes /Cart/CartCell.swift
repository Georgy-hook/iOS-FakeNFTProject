//
//  CartCell.swift
//  FakeNFT
//
//  Created by Georgy on 04.11.2023.
//

import UIKit
import Kingfisher

final class CartCell: UITableViewCell{
    static let reuseId = "CartCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor(named: "YP Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor(named: "YP Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor(named: "YP Black")
        label.text = NSLocalizedString("Price", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let NFTImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cartDelete"), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let ratingControl = RatingControl()
    
    weak var delegateVC:CartViewControllerDelegate?
    private var nftID: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear    
        addSubviews()
        applyConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension CartCell {
    private func addSubviews() {
        contentView.addSubview(deleteButton)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(priceTitleLabel)
        addSubview(NFTImageView)
        addSubview(ratingControl)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            NFTImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            NFTImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            NFTImageView.heightAnchor.constraint(equalToConstant: 108),
            NFTImageView.widthAnchor.constraint(equalToConstant: 108),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
            ratingControl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingControl.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
            priceTitleLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
            priceTitleLabel.topAnchor.constraint(equalTo: ratingControl.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}

// MARK: - Cell's methods
extension CartCell{
    func set(with nft:Nft){
        nftID = nft.id
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        ratingControl.rating = nft.rating
        NFTImageView.kf.setImage(with: nft.images.first, placeholder: UIImage(named: "Vector"))
        deleteButton.addTarget(self, action: #selector(didDeleteButtonTapped), for: .touchUpInside)
    }
    
    @objc func didDeleteButtonTapped(){
        guard let image = NFTImageView.image,
              let id = nftID
        else { return }
        
        delegateVC?.didCellDeleteButtonTapped(with: image, id: id)
    }
}
