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
    
    private let networkClient: NetworkClient
    
    weak var view: CatalogViewControllerProtocol?
    
    var collectionsCount: Int {
        return collections.count
    }
    
    private var collections: [CollectionModel] = []
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
            
    func getCollectionsIndex(_ index: Int) -> CollectionModel? {
        collections[index]
    }
        
    func viewDidLoad() {
        loadCollection()
    }
    
    private func loadCollection() {
        DispatchQueue.global().async {
            self.networkClient.send(request: GetCollectionsRequest(), type: [CollectionModel].self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self.collections = model
                        self.view?.updateTableView()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

