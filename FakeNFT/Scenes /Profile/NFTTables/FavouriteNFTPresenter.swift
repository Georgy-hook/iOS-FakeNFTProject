//  FavouriteNFTPresenter.swift
//  FakeNFT
//  Created by Adam West on 08.11.2023.

import Foundation
protocol InterfaceFavouriteNFTPresenter: AnyObject {
    var view: InterfaceFavouriteNFTController? { get set }
    var collectionsCount: Int { get }
    func viewDidLoad()
    func getCollectionFavoritesNFT() -> [Nft]
    func addToCollectionFavoritesNFT(_ currentNft: Nft)
    func removeFromCollectionFavoritesNFT(_ currentNft: Nft)
    func configureCell(with cell: FavouriteNFTCell, indexPath: IndexPath) -> FavouriteNFTCell
}

protocol InterfaceFavouriteNFTCell: AnyObject {
    func removeFromCollectionFavoritesNFT(_ currentNft: Nft)
}

final class FavouriteNFTPresenter: InterfaceFavouriteNFTPresenter, InterfaceFavouriteNFTCell {
    // MARK: Public Properties
    var collectionsCount: Int {
        return favoritesNFTProfile.count
    }
    
    // MARK: FavouriteNFTViewController
    weak var view: InterfaceFavouriteNFTController?
    
    // MARK: Private properties
    private var favoritesNFT: [String]
    private var favoritesNFTProfile: [Nft]
    private let servicesAssembly: ServicesAssembly
    
    // MARK: Initialisation
    init(servicesAssembly: ServicesAssembly) {
        self.favoritesNFT = []
        self.favoritesNFTProfile = []
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: Life cycle
    func viewDidLoad() {
        view?.showLoading()
        setupDataProfile()
    }
    
    // MARK: Setup Data Profile
    private func setupDataProfile() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let numberOfProfile = "1"
            servicesAssembly.profileService.loadProfile(id: numberOfProfile) { result in
                switch result {
                case .success(let profile):
                    self.favoritesNFT = profile.likes
                    self.loadRequest(self.favoritesNFT) { nft in
                        self.favoritesNFTProfile.append(nft)
                        self.view?.reloadData()
                    }
                case .failure:
                    self.view?.showErrorAlert()
                }
            }
        }
    }
    
    private func loadRequest(_ favoritesNFT: [String], _ completion: @escaping(Nft)->()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            favoritesNFT.forEach { nft in
                DispatchQueue.main.async {
                    self.servicesAssembly.nftService.loadNft(id: nft) { result in
                        switch result {
                        case .success(let nft):
                            completion(nft)
                        case .failure:
                            self.ressetAllData()
                            self.view?.showErrorAlert()
                        }
                        self.view?.hideLoading()
                    }
                }
            }
        }
    }
    
    private func ressetAllData() {
        self.favoritesNFT = []
        self.favoritesNFTProfile = []
    }
    
    // MARK: Configure Cell
    func configureCell(with cell: FavouriteNFTCell, indexPath: IndexPath) -> FavouriteNFTCell {
        cell.delegate = self
        let favoritesNFTProfile = favoritesNFTProfile[indexPath.row]
        cell.configure(with: favoritesNFTProfile)
        return cell
    }
    
    // MARK: Delegate InterfaceFavouriteNFTCell
    func removeFromCollectionFavoritesNFT(_ currentNft: Nft) {
        favoritesNFTProfile.removeAll(where: {$0 == currentNft})
        view?.reloadData()
    }
    
    // MARK: Add to collection for MYNFTPresenter
    func addToCollectionFavoritesNFT(_ currentNft: Nft) {
        guard favoritesNFTProfile.contains(where: {$0 == currentNft} ) else {
            return
        }
        favoritesNFTProfile.append(currentNft)
        view?.reloadData()
        
    }
    
    // MARK: Get collection to ProfilePresenter
    func getCollectionFavoritesNFT() -> [Nft] {
        return favoritesNFTProfile
    }
}
