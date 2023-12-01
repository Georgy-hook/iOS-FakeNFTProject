//  ProfileRequest.swift
//  FakeNFT
//  Created by Adam West on 15.11.2023.

import Foundation

struct ProfileRequest: NetworkRequest {
    
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
}
