//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Georgy on 08.11.2023.
//

import Foundation

typealias CurrencyCompletion = (Result<CurrencyModel, Error>) -> Void
typealias OrderCompletion = (Result<OrderModel, Error>) -> Void

protocol CurrencyService{
    func loadCurrencies(completion: @escaping CurrencyCompletion)
    func checkPaymentResult(with id:String, completion: @escaping OrderCompletion)
}


final class CurrencyServiceImpl:CurrencyService{
    private let networkClient: NetworkClient
    private let storage: CurrencyStorage
    
    init(networkClient: NetworkClient, storage: CurrencyStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadCurrencies(completion: @escaping CurrencyCompletion) {
        let request = CurrencyRequest()
        networkClient.send(request: request, type: CurrencyModel.self, onResponse: completion)
    }
    
    func checkPaymentResult(with id:String, completion: @escaping OrderCompletion){
        let request = OrderRequest(id: id)
        networkClient.send(request: request, type: OrderModel.self, onResponse: completion)
    }
}
