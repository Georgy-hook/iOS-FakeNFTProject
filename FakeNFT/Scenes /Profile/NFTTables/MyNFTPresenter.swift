//  MyNFTPresenter.swift
//  FakeNFT
//  Created by Adam West on 08.11.2023.

import Foundation

protocol InterfaceMyNFTPresenter: AnyObject {
    var view: InterfaceMyNFTController? { get set }
    var delegateToFavouriteNft: InterfaceFavouriteNFTPresenter? { get set }
    var collectionsCount: Int { get }
    func configureCell(_ indexpath: IndexPath) -> MyNFTCell
    func typeSorted(type: sotringOption)
    func viewDidLoad()
}

// MARK: Sotring option
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
    
    // MARK: MyNFTViewController
    weak var view: InterfaceMyNFTController?
    
    // MARK: Delegate
    var delegateToFavouriteNft: InterfaceFavouriteNFTPresenter?
    
    // MARK: Private properties
    private var myNFT: [String]
    private var favoritesNFT: [String]
    private var myNFTProfile: [Nft]
    private var myNFTUsers: [User] {
        didSet {
            view?.reloadData()
        }
    }
    private let nftService: NftServiceImpl
    private let profileService: ProfileServiceImpl
    private let userService: UserServiceImpl
    
    // MARK: Initialization
    init() {
        self.myNFT = []
        self.favoritesNFT = []
        self.myNFTProfile = []
        self.myNFTUsers = []
        self.nftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
        self.profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), profileStorage: ProfileStorageImpl())
        self.userService = UserServiceImpl(networkClient: DefaultNetworkClient(), storage: UserStorageImpl())
    }
    
    // MARK: Life cycle
    func viewDidLoad() {
        view?.showLoading()
        setupDataProfile()
    }
    
    // MARK: Setup Data Profile
    private func setupDataProfile() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.profileService.loadProfile(id: "1") { result in
                switch result {
                case .success(let profile):
                    self.myNFT = profile.nfts
                    self.favoritesNFT = profile.likes
                    self.loadRequest(self.myNFT) { nft in
                        self.myNFTProfile.append(nft)
                        self.loadUser(nft: nft) { }
                    }
                case .failure:
                    self.view?.showErrorAlert()
                }
            }
        }
    }
    
    // MARK: Load request & user
    private func loadRequest(_ myNFT: [String], _ completion: @escaping(Nft)->()) {
        assert(Thread.isMainThread)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            myNFT.forEach { nft in
                self.nftService.loadNft(id: nft) { result in
                    switch result {
                    case .success(let nft):
                        completion(nft)
                    case .failure:
                        self.view?.showErrorAlert()
                    }
                    self.view?.hideLoading()
                }
            }
        }
    }
    
    private func loadUser(nft: Nft, _ completion: @escaping()->()) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.userService.loadUser(id: nft.author) { result in
                switch result {
                case .success(let user):
                    self.myNFTUsers.append(user)
                    completion()
                case .failure:
                    self.view?.showErrorAlert()
                }
            }
        }
    }
    
    // MARK: Configure Cell
    func configureCell(_ indexpath: IndexPath) -> MyNFTCell {
        let cell = MyNFTCell()
        var myNFTProfile = myNFTProfile[indexpath.row]
        let likedIDs = myNFT.filter { favoritesNFT.contains($0) }
        likedIDs.forEach { id in
            myNFTProfile.id == id ? (myNFTProfile.like = true) : (myNFTProfile.like = false)
        }
        var myNFTUser = User()
        if myNFTUsers.count == self.myNFTProfile.count {
            myNFTUser = myNFTUsers[indexpath.row]
        }
        cell.delegate = self
        cell.configure(with: myNFTProfile, user: myNFTUser)
        return cell
    }
    
    // MARK: Add like Nft to favourite
    func isLikedNft(id: String, isLiked: Bool) {
       var searchNFT = myNFTProfile.first { $0.id == id }
        myNFTProfile.removeAll(where: { $0 == searchNFT })
        searchNFT?.like = isLiked
        guard let searchNFT else { return }
        myNFTProfile.append(searchNFT)
    }
    
    func addLikeNftToFavourite(_ currentNft: Nft, isLiked: Bool) {
        isLiked ? delegateToFavouriteNft?.addToCollectionFavoritesNFT(currentNft) : delegateToFavouriteNft?.removeFromCollectionFavoritesNFT(currentNft)
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

