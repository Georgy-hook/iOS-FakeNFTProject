//  MyNFTViewController.swift
//  FakeNFT
//  Created by Adam West on 04.11.2023.

import UIKit
import Kingfisher

final class MyNFTViewController: UIViewController & InterfaceMyNFTViewController {
    // MARK: Public properties
    var myNFT: [String] = []
    var favoritesNFT: [String] = []
    
    // MARK: Private properties
    private lazy var myNFTProfile: [Nft] = []
    private var emptyLabel = MyNFTLabel(labelType: .big, text: "У Вас еще нет NFT")
    private let nftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
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
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadRequest(myNFT)
        showEmptyLabel()
    }
    
    // MARK: Load Request
    func loadRequest(_ myNFT: [String]) {
        assert(Thread.isMainThread)
        myNFT.forEach { [weak self] nft in
            guard let self = self else { return }
            self.nftService.loadNft(id: nft) { result in
                switch result {
                case .success(let nft):
                    self.myNFTProfile.append(nft)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: Methods
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
            myNFTProfile = myNFTProfile.sorted { $0.price < $1.price }
            tableView.reloadData()
        }
        let raitingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
             guard let self else { return }
            myNFTProfile = myNFTProfile.sorted { $0.rating < $1.rating }
            tableView.reloadData()
        }
        let nameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
             guard let self else { return }
            myNFTProfile = myNFTProfile.sorted { $0.name < $1.name }
            tableView.reloadData()
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
        return myNFTProfile.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell() as MyNFTCell
        let cell = MyNFTCell()
        let myNFTProfile = myNFTProfile[indexPath.row]
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
