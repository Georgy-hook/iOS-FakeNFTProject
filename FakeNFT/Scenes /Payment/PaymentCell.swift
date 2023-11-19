//
//  PaymentCell.swift
//  FakeNFT
//
//  Created by Georgy on 07.11.2023.
//

import UIKit
import Kingfisher

class PaymentCell: UICollectionViewCell {
    
    static let reuseId = "PaymentCell"
    
    private let currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(named: "YP Black")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.kf.indicatorType = .activity
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
        layer.cornerRadius = 12
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
private extension PaymentCell {
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
    func set(with currency:CurrencyModelElement){
        nameLabel.text = currency.title
        abbreviationLabel.text = currency.name
        guard let url = URL(string: currency.image) else { return }
        currencyImageView.kf.setImage(with: url)
    }
    
    func selected(){
        layer.borderColor = UIColor(named: "YP Black")?.cgColor
        layer.borderWidth = 1
    }
    
    func deselected(){
        layer.borderWidth = 0
    }
}
