//  MyNFTPresenter.swift
//  FakeNFT
//  Created by Adam West on 08.11.2023.

import Foundation

protocol InterfaceMyNFTPresenter: AnyObject {
    var view: InterfaceMyNFTController? { get set }
    var collectionsCount: Int { get }
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
    private var myNFTUsers: [User]
    private let nftService: NftServiceImpl
    private let profileService: ProfileServiceImpl
    private let userService: UserServiceImpl
    
    // MARK: MyNFTViewController
    weak var view: InterfaceMyNFTController?
    
    // MARK: Initialisation
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
        DispatchQueue.main.async {
            self.profileService.loadProfile(id: "1") { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let profile):
                    self.myNFT = profile.nfts
                    self.favoritesNFT = profile.likes
                    self.loadRequest(myNFT) { [weak self] nft in
                        guard let self else { return }
                        self.myNFTProfile.append(nft)
                        self.loadUser(nft: nft) {
                            self.view?.reloadData()
                        }
                    }
                case .failure:
                    self.view?.showErrorAlert()
                }
            }
        }
    }
    
    private func loadRequest(_ myNFT: [String], _ completion: @escaping(Nft)->()) {
        assert(Thread.isMainThread)
        myNFT.forEach { [weak self] nft in
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
    
    private func loadUser(nft: Nft, _ completion: @escaping()->()) {
        userService.loadUser(id: nft.author) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.myNFTUsers.append(user)
                completion()
            case .failure:
                self.view?.showErrorAlert()
            }
        }
    }
    
    func configureCell(_ indexpath: IndexPath) -> MyNFTCell {
        let cell = MyNFTCell()
        let myNFTProfile = myNFTProfile[indexpath.row]
        var myNFTUser = User()
        if !myNFTUsers.isEmpty {
            myNFTUser = myNFTUsers[indexpath.row]
        }
        let likesNFT = favoritesNFT.filter{ myNFT.contains($0) }
        likesNFT.forEach { nftResult in
            if myNFTProfile.id == nftResult {
                cell.likeButton.isSelected = true
            }
        }
        cell.configure(with: myNFTProfile, user: myNFTUser)
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

