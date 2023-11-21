//  ProfilePutRequest.swift
//  FakeNFT
//  Created by Adam West on 15.11.2023.

import Foundation

struct ProfilePutRequest: NetworkRequest {
    
    let name: String
    let avatar: String
    let description: String
    let website: String
    var nfts: [String]
    var likes: [String]
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable?{
        Profile(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nfts: nfts,
            likes: likes,
            id: id)
    }
}
