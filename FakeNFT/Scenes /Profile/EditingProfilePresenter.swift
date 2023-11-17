//  EditingProfilePresenter.swift
//  FakeNFT
//  Created by Adam West on 16.11.2023.

import Foundation

protocol InterfaceEditingProfilePresenter: AnyObject {
    var view: InterfaceEditingProfileController? { get set }
    func updateImage(avatarImageView: String?) -> String?
    func updateTumbler(_ newValue: Bool?) -> Bool
    func updateLink(newValue: String?)
}

final class EditingProfilePresenter: InterfaceEditingProfilePresenter {
    // MARK: Private properties
    private var imageLink: String?
    private var tumblerUpdateAvatar: Bool
    
    // MARK: Controller 
    weak var view: InterfaceEditingProfileController?
    
    // MARK: Initialisation
    init() {
        self.tumblerUpdateAvatar = false
    }
    
    // MARK: Methods
    func updateImage(avatarImageView: String?) -> String? {
        return tumblerUpdateAvatar ? imageLink : avatarImageView
    }
    
    func updateLink(newValue: String?) {
        imageLink = newValue
    }
    
    func updateTumbler(_ newValue: Bool?) -> Bool {
        guard let newValue else {
            return tumblerUpdateAvatar
        }
        tumblerUpdateAvatar = newValue
        return tumblerUpdateAvatar
    }
}
