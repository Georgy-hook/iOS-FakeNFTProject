//  ProfileStorage.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import Foundation

protocol ProfileStorage: AnyObject {
    func saveProfile(_ profile: Profile)
    func getProfile(with id: String) -> Profile?
}

final class ProfileStorageImpl: ProfileStorage {
    private var storage: [String: Profile] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveProfile(_ profile: Profile) {
        syncQueue.async { [weak self] in
            self?.storage[profile.id] = profile
        }
    }

    func getProfile(with id: String) -> Profile? {
        syncQueue.sync {
            storage[id]
        }
    }
}
