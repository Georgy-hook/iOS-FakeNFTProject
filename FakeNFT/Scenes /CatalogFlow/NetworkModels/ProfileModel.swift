//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Руслан  on 17.11.2023.
//

import Foundation

/// Для экрана коллекции
struct ProfileModel: Codable {
    let nfts: [String]
    var likes: [String]
}
