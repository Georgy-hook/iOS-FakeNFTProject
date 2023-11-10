//  MyNFTPresenter.swift
//  FakeNFT
//  Created by Adam West on 08.11.2023.

import Foundation

protocol InterfaceMyNFTPresenter: AnyObject {
    var view: InterfaceMyNFTController? { get set }
    var collectionsCount: Int { get }
    func getCollectionsIndex(_ index: Int) -> Nft
    func configureCell(_ indexpath: IndexPath) -> MyNFTCell
    func typeSorted(type: sotringOption)
    func viewDidLoad()
}

enum sotringOption {
    case price
    case rating
    case name
}

final class MyNFTPresenter: InterfaceMyNFTPresenter {
    // MARK: Public Properties
    var collectionsCount: Int {
        return myNFTProfile.count
    }
    
    // MARK: Private properties
    private var myNFT: [String]
    private var favoritesNFT: [String]
    private var myNFTProfile: [Nft]
    private let nftService: NftServiceImpl 
    private let profileService: ProfileServiceImpl
    
    // MARK: MyNFTViewController
    weak var view: InterfaceMyNFTController?
    
    // MARK: Initialisation
    init() {
        self.myNFT = []
        self.favoritesNFT = []
        self.myNFTProfile = []
        self.nftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
        self.profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), profileStorage: ProfileStorageImpl())
    }
    
    // MARK: Life cycle
    func viewDidLoad() {
        setupDataProfile()
    }
    
    // MARK: Setup Data Profile
    private func setupDataProfile() {
        profileService.loadProfile(id: "1") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.myNFT = profile.nfts
                self.favoritesNFT = profile.likes
                self.loadRequest(myNFT) { [weak self] nft in
                    guard let self else { return }
                    self.myNFTProfile.append(nft)
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
                    completion(nft)
                case .failure:
                    self.view?.showErrorAlert()
                }
            }
        }
    }
    
    // MARK: Methods
    func getCollectionsIndex(_ index: Int) -> Nft {
        return myNFTProfile[index]
    }
    
    func configureCell(_ indexpath: IndexPath) -> MyNFTCell {
        let cell = MyNFTCell()
        let myNFTProfile = getCollectionsIndex(indexpath.row)
        let likesNFT = favoritesNFT.filter{ myNFT.contains($0) }
        likesNFT.forEach { nftResult in
            if myNFTProfile.id == nftResult {
                cell.likeButton.isSelected = true
            }
        }
        cell.configure(with: myNFTProfile)
        return cell
    }
    
    // MARK: Methods of sorting
    func typeSorted(type: sotringOption) {
        switch type {
        case .price: 
            sortedByPrice()
        case .rating:
            sortedByRating()
        case .name: 
            sortedByName()
        }
    }
    private func sortedByPrice() {
        myNFTProfile = myNFTProfile.sorted { $0.price < $1.price }
        view?.reloadData()
    }
    
    private func sortedByRating() {
        myNFTProfile = myNFTProfile.sorted { $0.rating < $1.rating }
        view?.reloadData()
    }
        
    private func sortedByName() {
        myNFTProfile = myNFTProfile.sorted { $0.name < $1.name }
        view?.reloadData()
    }
}
