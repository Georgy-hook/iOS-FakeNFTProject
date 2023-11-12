//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Georgy on 04.11.2023.
//

import UIKit

protocol CartView:AnyObject, ErrorView, LoadingView, SortOptionsView {
    func setTableView(with nfts:[Nft])
    func setPrice(with price:Float)
    func cartIsEmpty()
    func setCount(with count:Int)
    func deleteStateChanged(with state:Bool)
}

protocol CartViewControllerDelegate:AnyObject{
    func didCellDeleteButtonTapped(with image:UIImage, id: String)
}

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
        label.text = "0 NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = "0 ETH"
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
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = NSLocalizedString("Сart is empty", comment: "")
        label.isHidden = true
        label.textColor = UIColor(named: "YP Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.frame = UIScreen.main.bounds
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.bodyRegular
        button.layer.cornerRadius = 12
        button.setTitleColor(UIColor(named: "YP Red"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Return", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.bodyRegular
        button.layer.cornerRadius = 12
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let acceptLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.text = NSLocalizedString("Are you sure you want remove an item from the trash?", comment: "")
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = UIColor(named: "YP Black")
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.isHidden = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    private let cartTableView = CartTableView()
    
    // MARK: - Variables
    private let presenter: CartViewPresenter
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addSubviews()
        applyConstraints()
        presenter.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc func payButtonDidTapped(){
        let currencyService = CurrencyServiceImpl(networkClient: DefaultNetworkClient(), storage: CurrencyStorageImpl())
        let paymentViewPresenter = PaymentViewPresenterImpl(service: currencyService)
        let paymentViewController = PaymentViewController(presenter: paymentViewPresenter)
        paymentViewPresenter.view = paymentViewController
        paymentViewController.modalPresentationStyle = .fullScreen
        present(paymentViewController, animated: true)
    }
    
    @objc func sortButtonDidTapped(){
        presenter.makeSortModel()
    }
    
    @objc func returnButtonDidTapped(){
        presenter.returnButtonDidTapped()
    }
    
    @objc func deleteButtonDidTapped(){
        presenter.deleteButtonDidTapped()
    }
}

// MARK: - Layout
extension CartViewController {
    private func configureUI() {
        view.backgroundColor = UIColor(named: "YP White")
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        cartTableView.delegateVC = self
        payButton.addTarget(self, action: #selector(payButtonDidTapped), for: .touchUpInside)
        sortButton.addTarget(self, action: #selector(sortButtonDidTapped), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(returnButtonDidTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(grayView)
        view.addSubview(sortButton)
        view.addSubview(cartTableView)
        view.addSubview(activityIndicator)
        view.addSubview(placeholderLabel)
        grayView.addSubview(priceLabel)
        grayView.addSubview(amountLabel)
        grayView.addSubview(payButton)
        view.addSubview(blurView)
        buttonsStackView.addArrangedSubview(deleteButton)
        buttonsStackView.addArrangedSubview(returnButton)
        view.addSubview(buttonsStackView)
        view.addSubview(acceptLabel)
        view.addSubview(nftImageView)

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
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            acceptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            acceptLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 16),
            buttonsStackView.topAnchor.constraint(equalTo: acceptLabel.bottomAnchor, constant: 20),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 262),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}

// MARK: - CartView protocol
extension CartViewController:CartView{
    func setTableView(with nfts:[Nft]){
        cartTableView.set(with: nfts)
    }
    
    func setPrice(with price:Float){
        priceLabel.text = "\(price) ETH"
    }
    
    func setCount(with count:Int){
        amountLabel.text = "\(count) NFT"
    }
    
    func cartIsEmpty(){
        grayView.isHidden = true
        sortButton.isHidden = true
        cartTableView.isHidden = true
        priceLabel.isHidden = true
        amountLabel.isHidden = true
        payButton.isHidden = true
        placeholderLabel.isHidden = false
    }
    
    func deleteStateChanged(with state:Bool){
        tabBarController?.tabBar.isHidden = !state
        blurView.isHidden = state
        buttonsStackView.isHidden = state
        acceptLabel.isHidden = state
        nftImageView.isHidden = state
    }
}

// MARK: - CartViewControllerDelegate protocol
extension CartViewController:CartViewControllerDelegate{
    func didCellDeleteButtonTapped(with image:UIImage, id: String){
        presenter.didCellDeleteButtonTapped(with: id)
        nftImageView.image = image
    }
}
