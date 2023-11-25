//
//  CollectionInteractor.swift
//  FakeNFT
//
//  Created by Руслан  on 22.11.2023.
//

import Foundation

protocol CollectionInteractorProtocol {
    func loadProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func loadOrder(completion: @escaping (Result<OrderModel, Error>) -> Void)
    func loadAuthor(_ id: String, completion: @escaping (Result<AuthorModel, Error>) -> Void)
    func loadNfts(_ id: String, completion: @escaping (Result<NftModel, Error>) -> Void)
    func reverseLike(cell: CollectionCellProtocol, id: String, profile: ProfileModel, completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func addDeleteInCart(cell: CollectionCellProtocol, id: String, order: OrderModel, completion: @escaping (Result<OrderModel, Error>) -> Void)
}

final class CollectionInteractor: CollectionInteractorProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        self.networkClient.send(request: GetProfileRequest(),
                                type: ProfileModel.self,
                                completionQueue: .main,
                                onResponse: completion)
        
    }
    
    func loadOrder(completion: @escaping (Result<OrderModel, Error>) -> Void) {
        self.networkClient.send(request: GetOrderRequest(),
                                type: OrderModel.self,
                                completionQueue: .main,
                                onResponse: completion)
        
    }
    
    func loadAuthor(_ id: String, completion: @escaping (Result<AuthorModel, Error>) -> Void) {
        self.networkClient.send(request: GetAuthorRequest(id: id),
                                type: AuthorModel.self,
                                completionQueue: .main,
                                onResponse: completion)
    }
    
    func loadNfts(_ id: String, completion: @escaping (Result<NftModel, Error>) -> Void) {
        self.networkClient.send(request: GetNftsRequest(id: id),
                                type: NftModel.self,
                                completionQueue: .main,
                                onResponse: completion)
    }
    
    func reverseLike(cell: CollectionCellProtocol, id: String, profile: ProfileModel, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        self.networkClient.send(request: PutProfileRequest(profile: profile),
                                type: ProfileModel.self,
                                completionQueue: .main, 
                                onResponse: completion)
    }
    
    func addDeleteInCart(cell: CollectionCellProtocol, id: String, order: OrderModel, completion: @escaping (Result<OrderModel, Error>) -> Void) {
        self.networkClient.send(request: PutOrderRequest(order: order),
                                type: OrderModel.self,
                                completionQueue: .main, 
                                onResponse: completion)
    }
}
