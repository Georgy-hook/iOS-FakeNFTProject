//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Руслан  on 07.11.2023.
//

import Foundation

// MARK: - In progress
protocol CollectionPresenterProtocol {
   
}

final class CollectionPresenter: CollectionPresenterProtocol {
    private let networkClient: NetworkClient
   
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}

