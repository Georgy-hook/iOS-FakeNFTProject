//  Profile.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import Foundation

struct Profile: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    var nfts: [String]
    var likes: [String]
    let id: String
    
    init(name: String, avatar: String, description: String, website: String, nfts: [String], likes: [String], id: String) {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.likes = likes
        self.id = id
    }
    init() {
        self.name = String()
        self.avatar = String()
        self.description = String()
        self.website = String()
        self.nfts = [String()]
        self.likes = [String()]
        self.id = String()
    }
}
