//
//  Request.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import Foundation

struct GetCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/collections")
    }
    var httpMethod: HttpMethod = .get
    var dto: Encodable?
}
