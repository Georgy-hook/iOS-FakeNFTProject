//  Profile.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import Foundation

struct Profile: Codable {
    var name: String
    var avatar: String
    var description: String
    var website: String
    var nfts: [String]
    var likes: [String]
    let id: String
    
    // MARK: Default
    init(name: String, avatar: String, description: String, website: String, nfts: [String], likes: [String], id: String) {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.likes = likes
        self.id = id
    }
    
    // MARK: Empty
    init() {
        self.name = String()
        self.avatar = String()
        self.description = String()
        self.website = String()
        self.nfts = [String()]
        self.likes = [String()]
        self.id = String()
    }
}

// MARK: - Decoding Data Profile
extension Profile {
    func encodeData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: "SavedProfile")
        }
    }
    func decodeData() -> Profile {
        if let savedProfile = UserDefaults.standard.object(forKey: "SavedProfile") as? Data {
            let decoder = JSONDecoder()
            if let loadedProfile = try? decoder.decode(Profile.self, from: savedProfile) {
                return loadedProfile
            }
        }
        return Profile()
    }
}
