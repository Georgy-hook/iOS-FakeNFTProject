//  ProfileAssembly.swift
//  FakeNFT
//  Created by Adam West on 10.11.2023.

import UIKit

final class ProfileAssembly {
    // MARK: Public Properties
    public var favouriteNftIsInit = false
    
    var profilePresenter: ProfilePresenter {
        ProfilePresenter()
    }
    var myNFTPresenter: MyNFTPresenter {
        MyNFTPresenter()
    }
    var favouriteNFTPresenter: FavouriteNFTPresenter {
        FavouriteNFTPresenter()
    }
    
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
    public func profilePresenter(presenter: InterfaceProfilePresenter, input: InterfaceProfileViewController) {
        let presenter = presenter
        presenter.view = input
        presenter.viewDidLoad()
    }
    
    public func buildwebViewer(with input: UIViewController, urlString: String) {
        webViewerController.loadRequest(with: urlString)
        let navigationController = UINavigationController(rootViewController: webViewerController)
        input.present(navigationController, animated: true)
    }
    
    public func buildMyNFT(with input: UIViewController) {
        myNFTViewController.title = "Мои NFT"
        let navigationController = UINavigationController(rootViewController: myNFTViewController)
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.modalPresentationStyle = .fullScreen
        input.present(navigationController, animated: true)
    }
    
    public func buildFavouriteNFT(with input: UIViewController) {
        favouriteNFTViewController.title = "Избранные NFT"
        let navigationController = UINavigationController(rootViewController: favouriteNFTViewController)
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.modalPresentationStyle = .fullScreen
        input.present(navigationController, animated: true)
        favouriteNftIsInit = true
    }
    
    public func buildEditingProfile(presenter: InterfaceProfilePresenter, with input: UIViewController, image: String?, name: String?, description: String?, website: String?) {
        presenter.setupDelegateEditingProfile(viewController: editingProfileViewController, image: image, name: name, description: description, website: website)
        input.present(editingProfileViewController, animated: true)
    }
    
    public func returnCountFavouriteNft() -> Int {
        return favouriteNFTViewController.presenter.collectionsCount
    }
}
