//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Georgy on 19.11.2023.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(id)")
    }
}
