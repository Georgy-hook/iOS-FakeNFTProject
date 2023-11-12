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
}

final class FavouriteNFTPresenter: InterfaceFavouriteNFTPresenter {
    // MARK: Public Properties
    var collectionsCount: Int {
        return favoritesNFTProfile.count
    }
    
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
    
    // MARK: FavouriteNFTViewController
    weak var view: InterfaceFavouriteNFTController?
    
    // MARK: Life cycle
    func viewDidLoad() {
        view?.showLoading()
        setupDataProfile()
    }
    
    // MARK: Setup Data Profile
    private func setupDataProfile() {
        profileService.loadProfile(id: "1") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.favoritesNFT = profile.likes
                self.loadRequest(favoritesNFT) { [weak self] nft in
                    guard let self else { return }
                    self.favoritesNFTProfile.append(nft)
                    self.view?.reloadData()
                }
            case .failure:
                self.view?.showErrorAlert()
            }
        }
    }
    
    private func loadRequest(_ favoritesNFT: [String], _ completion: @escaping(Nft)->()) {
        assert(Thread.isMainThread)
        favoritesNFT.forEach { [weak self] nft in
            guard let self = self else { return }
            self.nftService.loadNft(id: nft) { result in
                switch result {
                case .success(let nft):
                    self.view?.hideLoading()
                    completion(nft)
                case .failure:
                    self.view?.hideLoading()
                    self.view?.showErrorAlert()
                }
            }
        }
    }
    
    // MARK: Methods
    func getCollectionsIndex(_ index: Int) -> Nft? {
        return favoritesNFTProfile[index]
    }
    
    func removeFromCollection(_ index: Int) {
        favoritesNFTProfile.remove(at: index)
    }
}
