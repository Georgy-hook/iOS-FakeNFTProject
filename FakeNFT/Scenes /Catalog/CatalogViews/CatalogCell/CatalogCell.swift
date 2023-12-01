//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Руслан  on 04.11.2023.
//

import UIKit

final class CatalogCell: UITableViewCell {
    
    // MARK: Private properties
    private let previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.Layout.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let previewText: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.textColor
        label.font = .bodyBold17
        return label
    }()
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        previewImage.kf.cancelDownloadTask()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: Constants.Layout.contentViewEdgeTop,
            left: Constants.Layout.contentViewEdgeLeftRight,
            bottom: .zero,
            right: Constants.Layout.contentViewEdgeLeftRight)
        )
    }
    
    func setupCell(_ collection: CollectionModel) {
        previewText.text = "\(collection.name) (\(collection.nfts.count))"
        guard let urlString = collection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else { return }
        previewImage.kf.indicatorType = .activity
        previewImage.kf.setImage(with: url, placeholder: UIImage(named: Constants.ImageNames.previewImagePlaceholder))
    }
}

private extension CatalogCell {
    func setupViews() {
        self.selectionStyle = .none
        self.backgroundColor = Constants.Colors.clear
        contentView.addSubviews(previewImage, previewText)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            previewImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            previewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            previewImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            previewImage.heightAnchor.constraint(equalToConstant: Constants.Layout.previewImageHeight),
            
            previewText.topAnchor.constraint(equalTo: previewImage.bottomAnchor, constant: Constants.Layout.previewTextTopAnchor),
            previewText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}

// MARK: - Constants
private extension CatalogCell {
    enum Constants {
        enum Layout {
            static let cornerRadius: CGFloat = 12
            static let previewImageHeight: CGFloat = 140
            static let previewTextTopAnchor: CGFloat = 4
            static let contentViewEdgeTop: CGFloat = 21
            static let contentViewEdgeLeftRight: CGFloat = 16
        }

        enum ImageNames {
            static let previewImagePlaceholder = "Catalog.collection.placeholder"
        }
        
        enum Colors {
            static let textColor = UIColor.textPrimary
            static let clear = UIColor.clear
        }
    }
}
