//
//  CatalogRouter.swift
//  FakeNFT
//
//  Created by Руслан  on 23.11.2023.
//

import UIKit

protocol CatalogRouter: AnyObject {
    func showCollection(for viewController: UIViewController, animated: Bool, collectionModel: CollectionModel)
}

// MARK: - CatalogRouter
extension Router: CatalogRouter {
    func showCollection(for viewController: UIViewController, animated: Bool, collectionModel: CollectionModel) {
        let collectionInteractor = CollectionInteractor(networkClient: DefaultNetworkClient())
        let collectionPresenter = CollectionPresenter(interactor: collectionInteractor, collections: collectionModel)
        let collectionViewController = CollectionViewController(presenter: collectionPresenter)
        collectionViewController.hidesBottomBarWhenPushed = true
        viewController.navigationController?.pushViewController(collectionViewController, animated: animated)
    }
}
