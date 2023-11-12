//  User.swift
//  FakeNFT
//  Created by Adam West on 12.11.2023.

import Foundation

struct User: Decodable {
    let name: String
    let id: String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    init() {
        self.name = String()
        self.id = String()
    }
}
