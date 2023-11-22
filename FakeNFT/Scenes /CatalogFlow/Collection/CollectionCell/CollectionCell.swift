//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import UIKit
import Kingfisher

protocol CollectionCellProtocol: AnyObject {
    func setIsLiked(isLiked: Bool)
    func setIsCart(isInCart: Bool)
}

protocol CollectionDelegate: AnyObject {
    func collectionCellDidTapLike(_ cell: CollectionCellProtocol, nftId: String)
    func collectionCellDidTapCart(_ cell: CollectionCellProtocol, nftId: String)
}

final class CollectionCell: UICollectionViewCell {
    
    weak var delegate: CollectionDelegate?
    
    // MARK: Private properties
    private var nftId: String = ""
    private let cache = ImageCache.default
    
    private let heartbeatAnimator: HeartbeatAnimatorProtocol
    
    private let previewImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(likeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let starsImages: [UIImageView] = {
        (1...5).map { _ in
            UIImageView()
        }
    }()
    
    private let titleLabel: UILabel = {
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
    
    private let cartButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(cartButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var starsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: starsImages)
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 0.75
        return view
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        self.heartbeatAnimator = HeartbeatAnimator()
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Public methods
    public override func prepareForReuse() {
        previewImage.kf.cancelDownloadTask()
    }
    
    func configureCell(_ nft: CollectionCellModel) {
//        cache.clearMemoryCache()
//        cache.clearDiskCache()
        
        nftId = nft.id
        titleLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        setStarsState(nft.rating)
        setIsLiked(isLiked: nft.isLiked)
        setIsCart(isInCart: nft.isInCart)
                
        guard let urlString = nft.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else { return }
        previewImage.kf.indicatorType = .activity
        previewImage.kf.setImage(with: url, placeholder: UIImage(named: "Catalog.nulImage"))
    }
    
    // MARK: Private methods
    private func setStarsState(_ state: Int) {
        starsImages.enumerated().forEach { position, star in
            star.image = position < state ? UIImage(named: "starDoneIcon") : UIImage(named: "defaultStarIcon")
        }
    }
    
    @objc
    private func likeButtonClicked() {
        likeButton.isUserInteractionEnabled = false
        delegate?.collectionCellDidTapLike(self, nftId: nftId)
    }
    
    @objc
    private func cartButtonClicked() {
        cartButton.isUserInteractionEnabled = false
        delegate?.collectionCellDidTapCart(self, nftId: nftId)
    }
}

// MARK: - Like and Cart Protocol
extension CollectionCell: CollectionCellProtocol {
    func setIsLiked(isLiked: Bool) {
        heartbeatAnimator.animationStart(with: likeButton, isLiked: isLiked)
    }
    
    func setIsCart(isInCart: Bool) {
        let cartImage = isInCart ? UIImage(named: "Catalog.CardFull") : UIImage(named: "Catalog.CardEmpty")
        self.cartButton.setImage(cartImage, for: .normal)
        likeButton.isUserInteractionEnabled = true
    }
}

// MARK: - Setup Views/Constraints
private extension CollectionCell {
    func setupViews() {
        self.backgroundColor = .clear
        contentView.addSubviews(previewImage, likeButton, starsStackView, titleLabel, priceLabel, cartButton)
        setupPreviewImage()
        setupLikeButton()
        setupStarsView()
        setupTitleLabel()
        setupPriceLabel()
        setupCartButton()
    }
    
    func setupPreviewImage() {
        NSLayoutConstraint.activate([
            previewImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            previewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            previewImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            previewImage.heightAnchor.constraint(equalTo: previewImage.widthAnchor)
        ])
    }
    
    func setupLikeButton() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: previewImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: previewImage.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setupStarsView() {
        NSLayoutConstraint.activate([
            starsStackView.topAnchor.constraint(equalTo: previewImage.bottomAnchor, constant: 8),
            starsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.75),
            starsStackView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func setupTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: previewImage.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func setupPriceLabel() {
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: previewImage.bottomAnchor, constant: 51),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func setupCartButton() {
        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(equalTo: previewImage.bottomAnchor, constant: 24),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}
