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
}
