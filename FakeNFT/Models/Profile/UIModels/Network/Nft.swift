//  Nft.swift
//  FakeNFT
//  Created by Adam West on 12.11.2023.

import Foundation

struct Nft: Decodable, Equatable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Float
    let author: String
    var like: Bool?
    
    init(id: String, name: String, images: [URL], rating: Int, price: Float, author: String, like: Bool?) {
        self.id = id
        self.name = name
        self.images = images
        self.rating = rating
        self.price = price
        self.author = author
        self.like = like
    }
    init() {
        self.id = String()
        self.name = String()
        self.images = [URL(fileURLWithPath: String())]
        self.rating = Int()
        self.price = Float()
        self.author = String()
        self.like = false
    }
}
