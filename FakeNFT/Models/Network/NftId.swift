//  NftId.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import Foundation

struct NftId: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
