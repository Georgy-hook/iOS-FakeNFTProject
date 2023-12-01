//
//  CartByldRequest.swift
//  FakeNFT
//
//  Created by Georgy on 06.11.2023.
//

import Foundation

struct CartRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
}
