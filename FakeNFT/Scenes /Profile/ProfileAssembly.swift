//  ProfileAssembly.swift
//  FakeNFT
//  Created by Adam West on 10.11.2023.

import UIKit

final class ProfileAssembly {
    // MARK: Public Properties
    public var favouriteNftIsInit = false
    
    // MARK: Private properties
    private let editingProfileViewController: EditingProfileViewController
    private let webViewerController: WebViewerController
    private let myNFTViewController: MyNFTViewController
    private let favouriteNFTViewController: FavouriteNFTViewController
    
    // MARK: Initialisation
    init(editingProfileViewController: EditingProfileViewController, webViewerController: WebViewerController, myNFTViewController: MyNFTViewController, favouriteNFTViewController: FavouriteNFTViewController) {
        self.editingProfileViewController = editingProfileViewController
        self.webViewerController = webViewerController
        self.myNFTViewController = myNFTViewController
        self.favouriteNFTViewController = favouriteNFTViewController
    }
    
    // MARK: Public Methods
    public func buildEditingProfile(with input: ProfileViewController, presenter: InterfaceProfilePresenter) {
        editingProfileViewController.presenter.view = editingProfileViewController
        input.presenter.setupDelegateEditingProfile(viewController: editingProfileViewController.presenter as! InterfaceEditingProfileViewPresenter)
        input.present(editingProfileViewController, animated: true)
    }
    
    public func buildMyNFT(with input: UIViewController) {
        myNFTViewController.title = "Мои NFT"
        myNFTViewController.presenter.view = myNFTViewController
        myNFTViewController.presenter.delegateToFavouriteNft = favouriteNFTViewController.presenter
        let navigationController = UINavigationController(rootViewController: myNFTViewController)
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.modalPresentationStyle = .fullScreen
        input.present(navigationController, animated: true)
    }
    
    public func buildFavouriteNFT(with input: UIViewController) {
        favouriteNFTViewController.title = "Избранные NFT"
        favouriteNFTViewController.presenter.view = favouriteNFTViewController
        let navigationController = UINavigationController(rootViewController: favouriteNFTViewController)
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.modalPresentationStyle = .fullScreen
        input.present(navigationController, animated: true)
        favouriteNftIsInit = true
    }
    
    public func buildwebViewer(with input: UIViewController, urlString: String) {
        webViewerController.loadRequest(with: urlString)
        let navigationController = UINavigationController(rootViewController: webViewerController)
        input.present(navigationController, animated: true)
    }
    
    public func returnFavouriteNft() -> [Nft] {
        return favouriteNFTViewController.presenter.getCollectionFavoritesNFT()
    }
}
