//  ProfilePresenter.swift
//  FakeNFT
//  Created by Adam West on 07.11.2023.

import Foundation

protocol InterfaceProfilePresenter: AnyObject {
    var titleRowsCount: Int { get }
    var view: InterfaceProfileViewController? { get set }
    func getProfileData() -> Profile?
    func getTitleRowsIndex(_ index: Int) -> String?
    func updateDataProfile(image: String?, name: String?, description: String?, website: String?, isUpdated: Bool)
    func updateFavouriteNftCount()
    func buildEditingProfile()
    func buildMyNFT()
    func buildFavouriteNFT()
    func buildwebViewer(text: String)
    func setupDelegateEditingProfile(viewController: InterfaceEditingProfileViewPresenter)
    func viewDidLoad()
}

final class ProfilePresenter: InterfaceProfilePresenter {
    // MARK: Public Properties
    var titleRowsCount: Int {
        return titleRows.count
    }
    
    // MARK: Delegate
    weak var delegateToEditing: InterfaceEditingProfileViewPresenter?
    
    // MARK: Controller
    weak var view: InterfaceProfileViewController?
    
    // MARK: Private properties
    private var myNFT: [String]
    private var favoritesNFT: [String]
    private var titleRows: [String]
    private var profile: Profile?
    private let profileService: ProfileServiceImpl
    private let profileAssembly: ProfileAssembly
    
    // MARK: Initialization
    init(profileAssembly: ProfileAssembly) {
        self.myNFT = [String]()
        self.favoritesNFT = [String]()
        self.titleRows = [ ]
        self.profileAssembly = profileAssembly
        self.profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), profileStorage: ProfileStorageImpl())
    }
    
    // MARK: Life cycle
    func viewDidLoad() {
        view?.showLoading()
        updateDataProfile()
    }
    
    // MARK: Get titleRows index
    func getTitleRowsIndex(_ index: Int) -> String? {
        return titleRows[index]
    }
    
    // MARK: Get profile
    func getProfileData() -> Profile? {
        return profile
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
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let numberOfProfile = "1"
            self.profileService.loadProfile(id: numberOfProfile) { result in
                switch result {
                case .success(let profile):
                    self.encodeData(profile)
                    completion(profile)
                case .failure:
                    self.decodeData()
                    completion(self.profile)
                    self.view?.showErrorAlert()
                }
                self.view?.hideLoading()
            }
        }
    }
    
     // MARK: Setup delegate
    func setupDelegateEditingProfile(viewController: InterfaceEditingProfileViewPresenter) {
        delegateToEditing = viewController
        guard let profile else { return }
        _ = delegateToEditing?.configureDataProfile(image: profile.avatar, name: profile.name, description: profile.description, website: profile.website)
    }
    
    func updateDataProfile(image: String?, name: String?, description: String?, website: String?, isUpdated: Bool) {
        if isUpdated {
            profile?.avatar = image ?? String()
        }
        profile?.name = name ?? String()
        profile?.description = description ?? String()
        profile?.website = website ?? String()
        putUpdatedDataProfile()
    }
    
    func updateFavouriteNftCount() {
        if profileAssembly.favouriteNftIsInit {
            let count = profileAssembly.returnFavouriteNft().count
            titleRows[1] = "Избранные NFT (\(count))"
            updateFavouriteNft()
            putUpdatedDataProfile()
            view?.reloadTable()
        }
    }
    
    private func updateFavouriteNft() {
        let favouriteNFTs = profileAssembly.returnFavouriteNft()
        let favouriteNFTsID = favouriteNFTs.map { $0.id }
        profile?.likes = favouriteNFTsID
    }
    
    // MARK: Make put Request to update data on server
    private func putUpdatedDataProfile() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            guard let profile else { return }
            self.profileService.updateProfile(
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nfts: profile.nfts,
                likes: profile.likes,
                id: profile.id, nil) 
        }
    }
    
    // MARK: Build All Controllers: 
    private func viewAsProfileController() -> ProfileViewController {
        guard let view = view as? ProfileViewController else {
            return ProfileViewController(presenter: self)
        }
        return view
    }
    /// EditingProfile
    func buildEditingProfile() {
        profileAssembly.buildEditingProfile(with: viewAsProfileController(), presenter: self)
    }
    /// MyNFT
    func buildMyNFT() {
        profileAssembly.buildMyNFT(with: viewAsProfileController())
    }
    /// FavouriteNFT
    func buildFavouriteNFT() {
        profileAssembly.buildFavouriteNFT(with: viewAsProfileController())
    }
    /// WebViewer
    func buildwebViewer(text: String) {
        profileAssembly.buildwebViewer(with: viewAsProfileController(), urlString: text)
    }
}

// MARK: - Decoding Data Profile
private extension ProfilePresenter {
    func encodeData(_ value: Profile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            UserDefaults.standard.set(encoded, forKey: "SavedProfile")
        }
    }
    func decodeData() {
        if let savedProfile = UserDefaults.standard.object(forKey: "SavedProfile") as? Data {
            let decoder = JSONDecoder()
            if let loadedProfile = try? decoder.decode(Profile.self, from: savedProfile) {
                self.profile = loadedProfile
            }
        }
    }
}
