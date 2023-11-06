//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Georgy on 04.11.2023.
//

import UIKit

final class CartViewController:UIViewController{
    
    // MARK: - Init

    init(presenter: CartViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Elements
    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let payButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("To pay", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor(named: "YP Black")
        label.text = "3 NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyRegular
        label.textColor = UIColor(named: "YP Green")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YP LightGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    // MARK: - Variables

    private let cartTableView = CartTableView()
    private let presenter: CartViewPresenter
    
    let service = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addSubviews()
        applyConstraints()
        
        service.loadNft(id: "22") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                self.cartTableView.set(with: [nft])
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Layout
extension CartViewController {
    private func configureUI() {
        view.backgroundColor = UIColor(named: "YP White")
    }
    
    private func addSubviews() {
        view.addSubview(grayView)
        view.addSubview(sortButton)
        view.addSubview(cartTableView)
        grayView.addSubview(priceLabel)
        grayView.addSubview(amountLabel)
        grayView.addSubview(payButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            grayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            grayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayView.heightAnchor.constraint(equalToConstant: 76),
            cartTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            cartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: grayView.topAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor),
            payButton.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -16),
            payButton.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            
        ])
    }
}

