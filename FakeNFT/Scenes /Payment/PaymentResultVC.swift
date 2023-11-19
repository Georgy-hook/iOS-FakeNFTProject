//
//  PaymentResultVC.swift
//  FakeNFT
//
//  Created by Georgy on 18.11.2023.
//

import UIKit

enum PaymentResultState {
    case  failed(Error), success
}

final class PaymentResultViewController:UIViewController{
    // MARK: - Init
    init(state:PaymentResultState) {
        currentState = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private let successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "paymentSuccess")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = UIColor(named: "YP Black")
        label.text = NSLocalizedString("Success! The payment went through Congratulations on your purchase!", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Return to catalog", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Variables
    let currentState:PaymentResultState
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addSubviews()
        applyConstraints()
    }
}

// MARK: - Layout
private extension PaymentResultViewController{
    private func configureUI() {
        
    }
    
    private func addSubviews() {
        view.addSubview(successLabel)
        view.addSubview(successImageView)
        view.addSubview(returnButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 196),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
