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
    private var favoritesNFTProfile: [Nft] = []
    private let nftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    
    // MARK: FavouriteNFTViewController
    weak var view: InterfaceFavouriteNFTController?
    
    // MARK: Initialisation
    func viewDidLoad() {
        guard let view else { return }
        loadRequest(view.favoritesNFT) { [weak self] nft in
            guard let self else { return }
            self.favoritesNFTProfile.append(nft)
            self.view?.reloadData()
        }
    }
    
    // MARK: Load Request
    func loadRequest(_ favoritesNFT: [String], _ completion: @escaping(Nft)->()) {
        assert(Thread.isMainThread)
        favoritesNFT.forEach { [weak self] nft in
            guard let self = self else { return }
            self.nftService.loadNft(id: nft) { result in
                switch result {
                case .success(let nft):
                    completion(nft)
                case .failure(let error):
                    print(error)
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
