//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Georgy on 07.11.2023.
//

import UIKit

protocol PaymentView:AnyObject, ErrorView, LoadingView {
    func setCollectionView(with currencies:CurrencyModel)
}
    
final class PaymentViewController:UIViewController{
    // MARK: - Init
    
    init(presenter: PaymentViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YP LightGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = NSLocalizedString("Select a Payment Method", comment: "")
        label.textColor = UIColor(named: "YP Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backWard"), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let payButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Pay", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.text = NSLocalizedString("By making a purchase, you agree to the terms and conditions", comment: "")
        label.textColor = UIColor(named: "YP Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.text = NSLocalizedString("User agreement", comment: "")
        label.textColor = UIColor(named: "YP Blue")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var activityIndicator = UIActivityIndicatorView()
    let paymentCollectionView = PaymentCollectionView()
    
    // MARK: - Variables
    private let presenter: PaymentViewPresenter
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addSubviews()
        applyConstraints()
        presenter.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc func didBackButtonTapped(){
        dismiss(animated: true)
    }
}

// MARK: - Layout
extension PaymentViewController{
    private func configureUI() {
        view.backgroundColor = UIColor(named: "YP White")
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(grayView)
        view.addSubview(activityIndicator)
        view.addSubview(paymentCollectionView)
        grayView.addSubview(payButton)
        grayView.addSubview(agreementLabel)
        grayView.addSubview(linkLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            grayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            grayView.heightAnchor.constraint(equalToConstant: 152),
            grayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            agreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreementLabel.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 16),
            linkLabel.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor),
            linkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            paymentCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            paymentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentCollectionView.bottomAnchor.constraint(equalTo: grayView.topAnchor),
        ])
    }
}

extension PaymentViewController: PaymentView{
    func setCollectionView(with currencies:CurrencyModel){
        paymentCollectionView.set(with: currencies)
    }
}
