//  FavouriteNFTPresenter.swift
//  FakeNFT
//  Created by Adam West on 08.11.2023.

import Foundation
protocol InterfaceFavouriteNFTPresenter: AnyObject {
    var view: InterfaceFavouriteNFTController? { get set }
    var collectionsCount: Int { get }
    func viewDidLoad()
    func getCollectionsIndex(_ index: Int) -> Nft?
    func removeFromCollection(_ index: Int)
    func getCollectionFavoritesNFT() -> [Nft]
    func addToCollectionFavoritesNFT(_ currentNft: Nft)
    func removeFromCollectionFavoritesNFT(_ currentNft: Nft)
}

final class FavouriteNFTPresenter: InterfaceFavouriteNFTPresenter {
    // MARK: Public Properties
    var collectionsCount: Int {
        return favoritesNFTProfile.count
    }
    
    // MARK: FavouriteNFTViewController
    weak var view: InterfaceFavouriteNFTController?
    
    // MARK: Private properties
    private var favoritesNFT: [String]
    private var favoritesNFTProfile: [Nft]
    private let nftService: NftServiceImpl
    private let profileService: ProfileServiceImpl
    
    // MARK: Initialisation
    init() {
        self.favoritesNFT = []
        self.favoritesNFTProfile = []
        self.nftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
        self.profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), profileStorage: ProfileStorageImpl())
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
            profileService.loadProfile(id: "1") { result in
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
        assert(Thread.isMainThread)
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            favoritesNFT.forEach { nft in
                self.nftService.loadNft(id: nft) { result in
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
    
    // MARK: Methods
    private func ressetAllData() {
        self.favoritesNFT = []
        self.favoritesNFTProfile = []
    }
    
    func getCollectionsIndex(_ index: Int) -> Nft? {
        return favoritesNFTProfile[index]
    }
    
    func removeFromCollection(_ index: Int) {
        favoritesNFTProfile.remove(at: index)
    }
    
    func getCollectionFavoritesNFT() -> [Nft] {
        return favoritesNFTProfile
    }
    
    func addToCollectionFavoritesNFT(_ currentNft: Nft) {
        guard favoritesNFTProfile.contains(where: {$0 == currentNft} ) else {
            return
        }
        favoritesNFTProfile.append(currentNft)
        view?.reloadData()
        
    }
    
    func removeFromCollectionFavoritesNFT(_ currentNft: Nft) {
        favoritesNFTProfile.removeAll(where: {$0 == currentNft})
        view?.reloadData()
    }
}
