//
//  Cart.swift
//  FakeNFT
//
//  Created by Georgy on 06.11.2023.
//

import Foundation

struct CartModel: Decodable{
    let nfts: [String]
    let id: String
}
