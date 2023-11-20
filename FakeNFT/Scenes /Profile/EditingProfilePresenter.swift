//  EditingProfilePresenter.swift
//  FakeNFT
//  Created by Adam West on 16.11.2023.

import Foundation

// MARK: DataProfile
struct DataProfile {
    var image: String?
    var name: String?
    var description: String?
    var website: String?
}

protocol InterfaceEditingProfileViewPresenter: AnyObject {
    func configureDataProfile(image: String?, name: String?, description: String?, website: String?) -> DataProfile
}

protocol InterfaceEditingProfilePresenter: AnyObject {
    var view: InterfaceEditingProfileController? { get set }
    func updateImage(avatarImageView: String?) -> String?
    func shouldUpdatedImage(_ newValue: Bool?) -> Bool
    func updateLink(newValue: String?)
    func dataProfileValues() -> DataProfile
}

final class EditingProfilePresenter: InterfaceEditingProfilePresenter, InterfaceEditingProfileViewPresenter {
    // MARK: Private properties
    private var imageLink: String?
    private var shouldUpdateAvatar: Bool
    private var dataProfile: DataProfile
    
    // MARK: Controller
    weak var view: InterfaceEditingProfileController?
    
    // MARK: Initialisation
    init() {
        self.shouldUpdateAvatar = false
        self.dataProfile = DataProfile()
    }
    
    // MARK: Methods
    func updateImage(avatarImageView: String?) -> String? {
        return shouldUpdateAvatar ? imageLink : avatarImageView
    }
    
    func updateLink(newValue: String?) {
        imageLink = newValue
    }
    
    func shouldUpdatedImage(_ newValue: Bool?) -> Bool {
        guard let newValue else {
            return shouldUpdateAvatar
        }
        shouldUpdateAvatar = newValue
        return shouldUpdateAvatar
    }
    
    // MARK: InterfaceEditingProfileViewPresenter delegate 
    func configureDataProfile(image: String?, name: String?, description: String?, website: String?) -> DataProfile {
        dataProfile = DataProfile(
            image: image,
            name: name,
            description: description,
            website: website)
        return dataProfile
    }
    
    func dataProfileValues() -> DataProfile {
        return dataProfile
    }
}
