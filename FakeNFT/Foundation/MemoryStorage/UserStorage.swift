//  UserStorage.swift
//  FakeNFT
//  Created by Adam West on 12.11.2023.

import Foundation

protocol UserStorage: AnyObject {
    func saveUser(_ user: User)
    func getUser(with id: String) -> User?
}

final class UserStorageImpl: UserStorage {
    private var storage: [String: User] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveUser(_ user: User) {
        syncQueue.async { [weak self] in
            self?.storage[user.id] = user
        }
    }

    func getUser(with id: String) -> User? {
        syncQueue.sync {
            storage[id]
        }
    }
}
