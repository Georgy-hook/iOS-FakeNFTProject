//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import UIKit

final class CollectionCell: UICollectionViewCell {
    
    // MARK: Private properties
    private let cardImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        // TODO: finish later
        button.setImage(UIImage(named: "noActiveLike"), for: .normal)
        button.addTarget(nil, action: #selector(likeButtonTap), for: .touchUpInside)
        return button
    }()
    
    private let starsImage: [UIImageView] = {
        (1...5).map { _ in
            UIImageView()
        }
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let cardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Catalog.CardFull"), for: .normal)
        button.addTarget(nil, action: #selector(cardButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var starsView: UIStackView = {
        let view = UIStackView(arrangedSubviews: starsImage)
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 0.75
        return view
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public func
    func configureCell(_ nfts: NftsModel?) {
        guard let nfts else { return }
        nameLabel.text = nfts.name
        setStarsState(nfts.rating)
        priceLabel.text = "\(nfts.price) ETH"
        
        guard let urlString = nfts.images[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else { return }
        cardImage.kf.indicatorType = .activity
        cardImage.kf.setImage(with: url, placeholder: UIImage(named: "Catalog.nulImage"))
    }
    
    // MARK: Private func
    private func setStarsState(_ state: Int) {
        starsImage.enumerated().forEach { position, star in
            star.image = position < state ? UIImage(named: "starDoneIcon") : UIImage(named: "defaultStarIcon")
        }
    }
    
    @objc
    private func likeButtonTap() {
        //TODO: finish this later
    }
    
    @objc
    private func cardButtonTap() {
        //TODO: finish this later
    }
}

// MARK: - Setup Views/Constraints
private extension CollectionCell {
    func setupViews() {
        self.backgroundColor = .clear
        contentView.addSubviews(cardImage, likeButton, starsView, nameLabel, priceLabel, cardButton)
        setupCardImage()
        setupLikeButton()
        setupStarsView()
        setupNameLabel()
        setupPriceLabel()
        setupCardButton()
    }
    
    func setupCardImage() {
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImage.heightAnchor.constraint(equalTo: cardImage.widthAnchor)
        ])
    }
    
    func setupLikeButton() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: cardImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cardImage.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setupStarsView() {
        NSLayoutConstraint.activate([
            starsView.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 8),
            starsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.75),
            starsView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func setupNameLabel() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func setupPriceLabel() {
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 51),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func setupCardButton() {
        NSLayoutConstraint.activate([
            cardButton.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 24),
            cardButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardButton.heightAnchor.constraint(equalToConstant: 40),
            cardButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}
