//
//  CatalogInteractor.swift
//  FakeNFT
//
//  Created by Руслан  on 19.11.2023.
//

import Foundation

protocol CatalogInteractorProtocol {
    func loadCollections(completion: @escaping (Result<[CollectionModel], Error>) -> Void)
}

final class CatalogInteractor: CatalogInteractorProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCollections(completion: @escaping (Result<[CollectionModel], Error>) -> Void) {
        self.networkClient.send(request: GetCollectionsRequest(), type: [CollectionModel].self, completionQueue: .main, onResponse: completion)
    }
}
