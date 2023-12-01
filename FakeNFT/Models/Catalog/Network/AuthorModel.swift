//
//  AuthorModel.swift
//  FakeNFT
//
//  Created by Руслан  on 17.11.2023.
//

import Foundation

/// Для экрана коллекции
struct AuthorModel: Decodable {
    let name: String
    let description: String
    let website: String
}
