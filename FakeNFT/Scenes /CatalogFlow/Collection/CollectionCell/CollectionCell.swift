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
    func setInteractionLike(isEnabled: Bool)
    func setInteractionCart(isEnabled: Bool)
}

protocol CollectionDelegate: AnyObject {
    func collectionCellDidTapLike(cell: CollectionCellProtocol, nftId: String)
    func collectionCellDidTapCart(cell: CollectionCellProtocol, nftId: String)
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
        view.layer.cornerRadius = Constants.Layout.cornerRadius
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
        Constants.Layout.numberOfStars.map { _ in
            UIImageView()
        }
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold17
        label.textColor = Constants.Colors.textColor
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .captionMedium10
        label.textColor = Constants.Colors.textColor
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
        view.spacing = Constants.Layout.starsStackViewSpacing
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
        priceLabel.text = "\(nft.price) \(Constants.Strings.currency)"
        setStarsState(nft.rating)
        setIsLiked(isLiked: nft.isLiked)
        setIsCart(isInCart: nft.isInCart)
                
        guard let urlString = nft.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else { return }
        previewImage.kf.indicatorType = .activity
        previewImage.kf.setImage(with: url, placeholder: UIImage(named: Constants.ImageNames.catalogNulImage))
    }
    
    // MARK: Private methods
    private func setStarsState(_ state: Int) {
        starsImages.enumerated().forEach { position, star in
            star.image = position < state ? UIImage(named: Constants.ImageNames.starDoneIcon) : UIImage(named: Constants.ImageNames.starEmptyIcon)
        }
    }
    
    @objc
    private func likeButtonClicked() {
        setInteractionLike(isEnabled: false)
        delegate?.collectionCellDidTapLike(cell: self, nftId: nftId)
    }
    
    @objc
    private func cartButtonClicked() {
        setInteractionCart(isEnabled: false)
        delegate?.collectionCellDidTapCart(cell: self, nftId: nftId)
    }
}

// MARK: - Like and Cart Protocol
extension CollectionCell: CollectionCellProtocol {
    func setIsLiked(isLiked: Bool) {
        heartbeatAnimator.animationStart(with: likeButton, isLiked: isLiked)
    }
    
    func setIsCart(isInCart: Bool) {
        let cartImage = isInCart ? UIImage(named: Constants.ImageNames.catalogCardFull) : UIImage(named: Constants.ImageNames.catalogCardEmpty)
        self.cartButton.setImage(cartImage, for: .normal)
    }
    
    func setInteractionLike(isEnabled: Bool) {
        likeButton.isUserInteractionEnabled = isEnabled
    }
    
    func setInteractionCart(isEnabled: Bool) {
        cartButton.isUserInteractionEnabled = isEnabled
    }
}

// MARK: - Setup Views/Constraints
private extension CollectionCell {
    func setupViews() {
        self.backgroundColor = Constants.Colors.clear
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
            likeButton.heightAnchor.constraint(equalToConstant: Constants.Layout.likeButtonHeight),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.Layout.likeButtonHeight),
        ])
    }
    
    func setupStarsView() {
        NSLayoutConstraint.activate([
            starsStackView.topAnchor.constraint(equalTo: previewImage.bottomAnchor, constant: Constants.Layout.starsStackViewTopAnchor),
            starsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .zero),
            starsStackView.heightAnchor.constraint(equalToConstant: Constants.Layout.starsStackViewHeight)
        ])
    }
    
    func setupTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: Constants.Layout.titleLabelTopAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.Layout.titleLabelHeight)
        ])
    }
    
    func setupPriceLabel() {
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Layout.priceLabelTopAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func setupCartButton() {
        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(equalTo: previewImage.bottomAnchor, constant: Constants.Layout.cartButtonTopAnchor),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: Constants.Layout.cartButtonHeight),
            cartButton.widthAnchor.constraint(equalToConstant: Constants.Layout.cartButtonWidth),
        ])
    }
}

// MARK: - Constants
private extension CollectionCell {
    enum Constants {
        enum Layout {
            static let numberOfStars = (1...5)
            static let starsStackViewSpacing = 0.75
            static let cornerRadius: CGFloat = 12
            static let cartButtonHeight: CGFloat = 40
            static let cartButtonWidth: CGFloat = 40
            static let likeButtonHeight: CGFloat = 40
            static let likeButtonWidth: CGFloat = 40
            static let starsStackViewTopAnchor: CGFloat = 8
            static let starsStackViewHeight: CGFloat = 12
            static let titleLabelTopAnchor: CGFloat = 5
            static let titleLabelHeight: CGFloat = 22
            static let priceLabelTopAnchor: CGFloat = 4
            static let cartButtonTopAnchor: CGFloat = 24
        }
        
        enum Strings {
            static let currency = "ETH"
        }

        enum ImageNames {
            static let catalogNulImage = "Catalog.nulImage"
            static let starDoneIcon = "starDoneIcon"
            static let starEmptyIcon = "starEmptyIcon"
            
            static let catalogCardFull = "Catalog.CardFull"
            static let catalogCardEmpty = "Catalog.CardEmpty"
        }
                
        enum Colors {
            static let textColor = UIColor.textPrimary
            static let clear = UIColor.clear
        }
    }
}
