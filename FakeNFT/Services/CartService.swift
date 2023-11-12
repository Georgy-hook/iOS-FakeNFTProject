//
//  CartService.swift
//  FakeNFT
//
//  Created by Georgy on 06.11.2023.
//

import Foundation

typealias CartCompletion = (Result<CartModel, Error>) -> Void
typealias NftsCompletion = (Result<[Nft], Error>) -> Void

protocol CartService{
    func loadNFTs(with id:String, completion: @escaping NftsCompletion)
    func removeFromCart(id: String, nfts: [Nft], completion: @escaping CartCompletion)
}

final class CartServiceImpl:CartService{
    private let networkClient: NetworkClient
    private let storage: CartStorage
    
    init(networkClient: NetworkClient, storage: CartStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadCart(id: String, completion: @escaping CartCompletion) {
        let request = CartRequest(id: id)
        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self, onResponse: completion)
    }
    
    func removeFromCart(id: String, nfts: [Nft], completion: @escaping CartCompletion) {
        let nftsString = nfts.map{ $0.id }
        let request = CartPutRequest(id: id, nfts: nftsString)
        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }
    
    func loadNFTs(with id:String, completion: @escaping NftsCompletion) {
        loadCart(id: id){ result in
            switch result{
            case .success(let cartModel):
                var nfts: [Nft] = []
                cartModel.nfts.forEach{
                    self.loadNft(id: $0){ result in
                        switch result{
                        case .success(let nft):
                            nfts.append(nft)
                            if nfts.count == cartModel.nfts.count {
                                completion(.success(nfts))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
