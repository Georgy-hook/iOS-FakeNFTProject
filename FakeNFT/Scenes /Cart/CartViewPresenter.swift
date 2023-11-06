//
//  CartViewPresenter.swift
//  FakeNFT
//
//  Created by Georgy on 04.11.2023.
//

import Foundation

// MARK: - Protocol

protocol CartViewPresenter {
    func viewDidLoad()
}

// MARK: - State

enum CartViewState {
    case initial, loading, failed(Error), data
}

final class CartViewPresenterImpl: CartViewPresenter{
    
    func viewDidLoad() {
        <#code#>
    }
    
    
}
