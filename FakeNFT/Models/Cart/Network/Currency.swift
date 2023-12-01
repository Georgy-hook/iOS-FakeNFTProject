//
//  Currency.swift
//  FakeNFT
//
//  Created by Georgy on 08.11.2023.
//

import Foundation

struct CurrencyModelElement: Codable {
    let title: String
    let name: String
    let image: String
    let id: String
}

typealias CurrencyModel = [CurrencyModelElement]
