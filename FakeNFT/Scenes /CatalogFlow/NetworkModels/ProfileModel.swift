//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Руслан  on 17.11.2023.
//

import Foundation

/// Для экрана коллекции
struct ProfileModel: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    var likes: [String]
    let id: String
}
