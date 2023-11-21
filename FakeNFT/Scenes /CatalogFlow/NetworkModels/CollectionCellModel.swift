//
//  CollectionCellModel.swift
//  FakeNFT
//
//  Created by Руслан  on 17.11.2023.
//

import Foundation

/// Для экрана коллекции
struct CollectionCellModel: Codable {
    let id: String
    let name: String
    let image: String
    var isLiked: Bool
    var isInCart: Bool
    let rating: Int
    let price: Float
}
