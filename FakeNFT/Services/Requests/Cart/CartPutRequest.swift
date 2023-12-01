//
//  CartPutRequest.swift
//  FakeNFT
//
//  Created by Georgy on 12.11.2023.
//

import Foundation

struct CartPutRequest: NetworkRequest {

    let id: String
    let nfts: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable?{
        CartModel(nfts: nfts, id: id)
    }
}
