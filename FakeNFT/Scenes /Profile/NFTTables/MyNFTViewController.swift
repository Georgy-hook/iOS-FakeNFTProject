//  MyNFTViewController.swift
//  FakeNFT
//  Created by Adam West on 04.11.2023.

import UIKit
import Kingfisher

protocol InterfaceMyNFTController: AnyObject  {
    var presenter: InterfaceMyNFTPresenter { get set }
    var myNFT: [String] { get set }
    func reloadData()
    func showErrorAlert()
}

final class MyNFTViewController: UIViewController & InterfaceMyNFTController, InterfaceMyNFTViewController {
    // MARK: Public properties
    var myNFT: [String]
    var favoritesNFT: [String]
    
    // MARK: Private properties
    private var emptyLabel = MyNFTLabel(labelType: .big, text: "У Вас еще нет NFT")

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(MyNFTCell.self)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        return tableView
    }()
    
    // MARK: Initialisation
    init() {
        self.myNFT = []
        self.favoritesNFT = []
        self.presenter = MyNFTPresenter()
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Presenter
    var presenter: InterfaceMyNFTPresenter 
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
        setupNavigationBar()
        showEmptyLabel()
    }
    
    // MARK: Methods
    func reloadData() {
        tableView.reloadData()
    }
    func showErrorAlert() {
        self.showErrorLoadAlert()
    }
    
    private func showEmptyLabel() {
        myNFT.isEmpty ? (emptyLabel.isHidden = false) : (emptyLabel.isHidden = true)
    }
    
    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            let editItem = UIBarButtonItem(image: UIImage(named: ImagesAssets.sort.rawValue), style: .plain, target: self, action: #selector(filterNFT))
            editItem.tintColor = .black
            navBar.topItem?.setRightBarButton(editItem, animated: true)
            
            let backItem = UIBarButtonItem(image: UIImage(named: ImagesAssets.backWard.rawValue), style: .plain, target: self, action: #selector(goBack))
            backItem.tintColor = .black
            navBar.topItem?.setLeftBarButton(backItem, animated: true)
        }
    }
    
    private func showFilterAlert() {
        let alert = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        let priceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            guard let self else { return }
            self.presenter.sortedByPrice()
        }
        let raitingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
             guard let self else { return }
            self.presenter.sortedByRating()
        }
        let nameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
             guard let self else { return }
            self.presenter.sortedByPrice()
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(priceAction)
        alert.addAction(raitingAction)
        alert.addAction(nameAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    // MARK: Selectors
    @objc private func filterNFT() {
        showFilterAlert()
    }
    @objc private func goBack() {
        dismiss(animated: true)
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension MyNFTViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.collectionsCount
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyNFTCell()
        guard let myNFTProfile = presenter.getCollectionsIndex(indexPath.row) else {
            return UITableViewCell()
        }
        if let image = myNFTProfile.images.first {
            cell.nftImageView.kf.indicatorType = .activity
            cell.nftImageView.kf.setImage(with: image)
        }
        favoritesNFT.forEach { nft in
            if myNFTProfile.id == nft {
                cell.likeButton.isSelected = true
            }
        }
        cell.nameLabel.text = myNFTProfile.name
        cell.ratingStar.rating = myNFTProfile.rating
        cell.authorLabel.text = myNFTProfile.author
        cell.priceLabel.text = String(myNFTProfile.price)
        return cell
    }
}

// MARK: - Setup views, constraints
private extension MyNFTViewController {
    func setupUI() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        view.addSubviews(tableView, emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
