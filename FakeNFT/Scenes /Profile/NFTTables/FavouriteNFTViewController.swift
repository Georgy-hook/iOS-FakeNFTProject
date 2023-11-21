//  FavouriteNFTViewController.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import UIKit
import Kingfisher

protocol InterfaceFavouriteNFTController: AnyObject, LoadingView {
    var presenter: InterfaceFavouriteNFTPresenter { get set }
    func reloadData()
    func showErrorAlert()
}

final class FavouriteNFTViewController: UIViewController & InterfaceFavouriteNFTController {
    // MARK: Public Properties
    var activityIndicator: UIActivityIndicatorView
    
    // MARK: Presenter
    var presenter: InterfaceFavouriteNFTPresenter
    
    // MARK: Private properties
    private var emptyLabel = MyNFTLabel(labelType: .big, text: "У Вас еще нет избранных NFT")
    private var params: GeometricParams = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 7)
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(FavouriteNFTCell.self)
        collectionView.backgroundColor = .systemBackground
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: .zero, bottom: .zero, right: .zero)
        return collectionView
    }()
    
    // MARK: Initialisation
    init(presenter: InterfaceFavouriteNFTPresenter) {
        self.presenter = presenter
        self.emptyLabel.isHidden = true
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: Public methods
    func reloadData() {
        collectionView.reloadData()
        showEmptyLabel()
    }
    func showErrorAlert() {
        self.showErrorLoadAlert()
    }
    
    // MARK: Private methods
    private func showEmptyLabel() {
        presenter.collectionsCount == 0 ? (emptyLabel.isHidden = false) : (emptyLabel.isHidden = true)
    }
    
    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            let backItem = UIBarButtonItem(image: UIImage(named: ImagesAssets.backWard.rawValue), style: .plain, target: self, action: #selector(goBack))
            backItem.tintColor = .black
            navBar.topItem?.setLeftBarButton(backItem, animated: true)
        }
    }
    
    private func configureCell(with indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as FavouriteNFTCell
        cell.delegate = self
        guard let favoritesNFTProfile = presenter.getCollectionsIndex(indexPath.row) else {
            return UICollectionViewCell()
        }
        cell.configure(with: favoritesNFTProfile)
        return cell
    }
    
    // MARK: Selectors
    @objc private func goBack() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension FavouriteNFTViewController: UICollectionViewDelegate & UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.collectionsCount 
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureCell(with: indexPath)
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
        view.addSubviews(collectionView, emptyLabel, activityIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
