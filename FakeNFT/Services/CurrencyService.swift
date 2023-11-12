//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Georgy on 08.11.2023.
//

import Foundation

typealias CurrencyCompletion = (Result<CurrencyModel, Error>) -> Void

protocol CurrencyService{
    func loadCurrencies(completion: @escaping CurrencyCompletion)
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
}
