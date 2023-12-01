//  UserRequest.swift
//  FakeNFT
//  Created by Adam West on 12.11.2023.

import Foundation

struct UserRequest: NetworkRequest {
    
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
}
