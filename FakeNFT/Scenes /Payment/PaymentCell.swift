//
//  PaymentCell.swift
//  FakeNFT
//
//  Created by Georgy on 07.11.2023.
//

import UIKit

class PaymentCell: UICollectionViewCell {
    
    static let reuseId = "PaymentCell"
    
    private let currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor(named: "YP Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let abbreviationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor(named: "YP Green")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "YP LightGray")
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension PaymentCell {
    private func addSubviews() {
        addSubview(currencyImageView)
        addSubview(abbreviationLabel)
        addSubview(nameLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            currencyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            currencyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            nameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            abbreviationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            abbreviationLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
        ])
    }
}

// MARK: - Cell's methods
extension PaymentCell {
    func set(){
        
    }
}
