//  ProfilePresenter.swift
//  FakeNFT
//  Created by Adam West on 07.11.2023.

import Foundation

protocol InterfaceProfilePresenter: AnyObject {
    var titleRows: [String] { get set }
    var profile: Profile? { get set }
    var view: InterfaceProfileViewController? { get set }
    func setupDelegateEditingProfile(viewController: EditingProfileViewController, image: String?, name: String?, description: String?, website: String?)
    func updateDataProfile(image: String?, name: String?, description: String?, website: String?, tumbler: Bool)
    func updateFavouriteNft()
    func putUpdatedDataProfile()
    func viewDidLoad()
}

final class ProfilePresenter: InterfaceProfilePresenter {
    // MARK: Public Properties
    var titleRows: [String] 
    var profile: Profile?
    
    // MARK: Delegates
    weak var delegateToEditing: InterfaceEditingProfileViewController?
    weak var view: InterfaceProfileViewController?
    
    // MARK: Private properties
    private var myNFT: [String]
    private var favoritesNFT: [String]
    private let profileService: ProfileServiceImpl
    
    // MARK: Initialisation
    init() {
        self.myNFT = [String]()
        self.favoritesNFT = [String]()
        self.titleRows = [ ]
        self.profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), profileStorage: ProfileStorageImpl())
    }
    
    // MARK: Life cycle
    func viewDidLoad() {
        view?.showLoading()
        updateDataProfile()
    }
    
    // MARK: Update Data Profile
    private func updateDataProfile() {
        setupDataProfile { [weak self] profile in
            guard let profile else { return }
            guard let self else { return }
            self.profile = profile
            self.myNFT = profile.nfts
            self.favoritesNFT = profile.likes
            self.titleRows = [
                "Мои NFT (\(self.myNFT.count))",
                "Избранные NFT (\(self.favoritesNFT.count))",
                "О разработчике"
            ]
            self.view?.reloadTable()
            self.view?.updateDataProfile()
        }
    }
    
    private func setupDataProfile(_ completion: @escaping(Profile?)->()) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.profileService.loadProfile(id: "1") { result in
                switch result {
                case .success(let profile):
                    completion(profile)
                case .failure:
                    self.view?.showErrorAlert()
                }
                self.view?.hideLoading()
            }
        }
    }
    
    // MARK: Setup delegate
    func setupDelegateEditingProfile(viewController: EditingProfileViewController, image: String?, name: String?, description: String?, website: String?) {
        delegateToEditing = viewController
        delegateToEditing?.configureDataProfile(image: image, name: name, description: description, website: website)
    }
    
    func updateDataProfile(image: String?, name: String?, description: String?, website: String?, tumbler: Bool) {
        if tumbler {
            profile?.avatar = image ?? String()
        }
        profile?.name = name ?? String()
        profile?.description = description ?? String()
        profile?.website = website ?? String()
    }
    
    func updateFavouriteNft() {
        guard let view else { return }
        let favouriteNFTs = view.getFavouriteNFT()
        let favouriteNFTsID = favouriteNFTs.map { $0.id }
        profile?.likes = favouriteNFTsID
    }
    
    func putUpdatedDataProfile() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let profile else { return }
            self.profileService.updateProfile(
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nfts: profile.nfts,
                likes: profile.likes,
                id: profile.id) { result in
                    switch result {
                    case .success(let profile):
                        print(profile)
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
}
