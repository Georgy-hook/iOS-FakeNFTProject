//  FavouriteNFTViewController.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import UIKit
import Kingfisher

final class FavouriteNFTViewController: UIViewController & InterfaceFavouriteNFTViewController {
    // MARK: Public properties
    var favoritesNFT: [String] = []
    
    // MARK: Private properties
    private lazy var favoritesNFTProfile: [Nft] = []
    private let nftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    private var emptyLabel = MyNFTLabel(labelType: .big, text: "У Вас еще нет избранных NFT")
    private var params: GeometricParams = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 7)
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(FavouriteNFTCell.self)
        collectionView.backgroundColor = .systemBackground
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: .zero, bottom: .zero, right: .zero)
        return collectionView
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        showEmptyLabel()
        loadRequest(favoritesNFT)
    }
    
    // MARK: Load Request
    func loadRequest(_ favoritesNFT: [String]) {
        assert(Thread.isMainThread)
        favoritesNFT.forEach { [weak self] nft in
            guard let self = self else { return }
            self.nftService.loadNft(id: nft) { result in
                switch result {
                case .success(let nft):
                    self.favoritesNFTProfile.append(nft)
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: Methods
    private func showEmptyLabel() {
        favoritesNFT.isEmpty ? (emptyLabel.isHidden = false) : (emptyLabel.isHidden = true)
    }
    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            let backItem = UIBarButtonItem(image: UIImage(named: ImagesAssets.backWard.rawValue), style: .plain, target: self, action: #selector(goBack))
            backItem.tintColor = .black
            navBar.topItem?.setLeftBarButton(backItem, animated: true)
        }
    }
    // MARK: Selectors
    @objc private func goBack() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension FavouriteNFTViewController: UICollectionViewDelegate & UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesNFTProfile.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as FavouriteNFTCell
        let favoritesNFTProfile = favoritesNFTProfile[indexPath.row]
        if let image = favoritesNFTProfile.images.first {
            cell.nftImageView.kf.setImage(with: image)
        }
        cell.nameLabel.text = favoritesNFTProfile.name
        cell.ratingStar.rating = favoritesNFTProfile.rating
        cell.priceLabel.text = String(favoritesNFTProfile.price)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension FavouriteNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

// MARK: - Setup views, constraints
private extension FavouriteNFTViewController {
    func setupUI() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        view.addSubviews(collectionView, emptyLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
