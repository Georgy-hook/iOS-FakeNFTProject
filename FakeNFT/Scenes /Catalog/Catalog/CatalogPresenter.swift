//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import Foundation

protocol CatalogPresenterProtocol {
    var view: CatalogViewControllerProtocol? { get set }
    var collectionsCount: Int { get }
    func viewDidLoad()
    func getCollectionsIndex(_ index: Int) -> CollectionModel?
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    weak var view: CatalogViewControllerProtocol?
    
    var collectionsCount: Int {
        return collections.count
    }
    
    private let networkClient: NetworkClient
    
    private var collections: [CollectionModel] = []
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
            
    func getCollectionsIndex(_ index: Int) -> CollectionModel? {
        collections[index]
    }
        
    func viewDidLoad() {
        view?.showLoading()
        loadCollection()
    }
    
    private func loadCollection() {
        DispatchQueue.global().async {
            self.networkClient.send(request: GetCollectionsRequest(), type: [CollectionModel].self) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        assert(Thread.isMainThread)
                        self?.view?.hideLoading()
                        self?.collections = model
                        self?.view?.updateTableView()
                        self?.view?.endRefreshing()
                    case .failure(let error):
                        self?.view?.hideLoading()
                        self?.view?.endRefreshing()
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

