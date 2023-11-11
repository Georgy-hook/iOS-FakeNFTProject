//
//  CollectionModel.swift
//  FakeNFT
//
//  Created by Руслан  on 07.11.2023.
//

import Foundation

struct CollectionModel: Decodable {
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
