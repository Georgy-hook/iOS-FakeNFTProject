//  ProfilePresenter.swift
//  FakeNFT
//  Created by Adam West on 07.11.2023.

import Foundation

protocol InterfaceMyNFTViewController: AnyObject {
    var myNFT: [String] { get set }
    var favoritesNFT: [String] { get set }
}

protocol InterfaceFavouriteNFTViewController: AnyObject {
    var favoritesNFT: [String] { get set }
}

protocol InterfaceProfilePresenter: AnyObject {
    var myNFT: [String] { get set }
    var favoritesNFT: [String] { get set }
    var titleRows: [String] { get set }
    var view: InterfaceProfileViewController? { get set }
    func viewDidLoad()
    func setupDataProfile(_ completion: @escaping(Profile?)->())
    func setupDelegateMyNFT(viewController: MyNFTViewController)
    func setupDelegateFavouriteNFT(viewController: FavouriteNFTViewController)
    func setupDelegateEditingProfile(viewController: EditingProfileViewController, image: String?, name: String?, description: String?, website: String?)
}
final class ProfilePresenter: InterfaceProfilePresenter {
    // MARK: Public Properties
    var myNFT: [String]
    var favoritesNFT: [String]
    var titleRows: [String] 
    
    // MARK: Delegates
    weak var delegateToEditing: InterfaceEditingProfileViewController?
    weak var delegateToMyNFT: InterfaceMyNFTViewController?
    weak var delegateToFavouriteNFT: InterfaceFavouriteNFTViewController?
    
    // MARK: Private properties
    private let profileService: ProfileServiceImpl
    
    // MARK: ProfileViewController
    weak var view: InterfaceProfileViewController?
    
    // MARK: Initialisation
    init() {
        self.myNFT = [String]()
        self.favoritesNFT = [String]()
        self.titleRows = [ ]
        self.profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), profileStorage: ProfileStorageImpl())
    }
    
    // MARK: Life cycle
    func viewDidLoad() {
        
    }
    
    // MARK: Setup delegates
    func setupDelegateMyNFT(viewController: MyNFTViewController) {
        delegateToMyNFT = viewController
        delegateToMyNFT?.myNFT = myNFT
        delegateToMyNFT?.favoritesNFT = favoritesNFT
    }
    
    func setupDelegateFavouriteNFT(viewController: FavouriteNFTViewController) {
        delegateToFavouriteNFT = viewController
        delegateToFavouriteNFT?.favoritesNFT = favoritesNFT
    }
    
    func setupDelegateEditingProfile(viewController: EditingProfileViewController, image: String?, name: String?, description: String?, website: String?) {
        delegateToEditing = viewController
        delegateToEditing?.configureDataProfile(image: image, name: name, description: description, website: website)
    }
    
    // MARK: Setup Network data
    func setupDataProfile(_ completion: @escaping(Profile?)->()) {
        profileService.loadProfile(id: "1") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.myNFT = profile.nfts
                self.favoritesNFT = profile.likes
                self.titleRows = [
                    "Мои NFT (\(myNFT.count))",
                    "Избранные NFT (\(favoritesNFT.count))",
                    "О разработчике"
                ]
                self.view?.reloadTable()
                completion(profile)
            case .failure:
                self.view?.showErrorAlert()
            }
        }
    }
}
