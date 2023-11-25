//
//  Request.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import Foundation

struct GetCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var httpMethod: HttpMethod = .get
    var dto: Decodable?
}

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .get
    var dto: Encodable?
}

struct GetOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .get
    var dto: Encodable?
}

struct GetAuthorRequest: NetworkRequest {
    var id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Decodable?
}

struct GetNftsRequest: NetworkRequest {
    var id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Decodable?
}

struct PutProfileRequest: NetworkRequest {
    let profile: ProfileModel
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Encodable? {
        profile
    }
}

struct PutOrderRequest: NetworkRequest {
    let order: OrderModel
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Encodable? {
        order
    }
}
