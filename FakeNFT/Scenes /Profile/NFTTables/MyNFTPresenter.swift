//  MyNFTPresenter.swift
//  FakeNFT
//  Created by Adam West on 08.11.2023.

import Foundation

protocol InterfaceMyNFTPresenter: AnyObject {
    var view: InterfaceMyNFTController? { get set }
    var collectionsCount: Int { get }
    func getCollectionsIndex(_ index: Int) -> Nft?
    func viewDidLoad()
    func sortedByPrice()
    func sortedByRating()
    func sortedByName()
    
}

final class MyNFTPresenter: InterfaceMyNFTPresenter {
    // MARK: Public Properties
    var collectionsCount: Int {
        return myNFTProfile.count
    }
    
    // MARK: Private properties
    private var myNFTProfile: [Nft]
    private let nftService: NftServiceImpl 
    
    // MARK: MyNFTViewController
    weak var view: InterfaceMyNFTController?
    
    // MARK: Initialisation
    init() {
        self.myNFTProfile = []
        self.nftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    }
    
    func viewDidLoad() {
        guard let view else { return }
        loadRequest(view.myNFT) { [weak self] nft in
            guard let self else { return }
            self.myNFTProfile.append(nft)
            self.view?.reloadData()
        }
    }
    
    // MARK: Load Request
    private func loadRequest(_ myNFT: [String], _ completion: @escaping(Nft)->()) {
        assert(Thread.isMainThread)
        myNFT.forEach { [weak self] nft in
            guard let self = self else { return }
            self.nftService.loadNft(id: nft) { result in
                switch result {
                case .success(let nft):
                    completion(nft)
                case .failure:
                    self.view?.showErrorAlert()
                }
            }
        }
    }
    
    // MARK: Methods
    func getCollectionsIndex(_ index: Int) -> Nft? {
        return myNFTProfile[index]
    }
    
    func sortedByPrice() {
        myNFTProfile = myNFTProfile.sorted { $0.price < $1.price }
        view?.reloadData()
    }
    
    func sortedByRating() {
        myNFTProfile = myNFTProfile.sorted { $0.rating < $1.rating }
        view?.reloadData()
    }
        
    func sortedByName() {
        myNFTProfile = myNFTProfile.sorted { $0.name < $1.name }
        view?.reloadData()
    }
}
