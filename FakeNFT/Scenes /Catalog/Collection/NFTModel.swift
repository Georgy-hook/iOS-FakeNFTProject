//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Руслан  on 13.11.2023.
//

import Foundation

struct NftModel: Codable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let id: String
}
