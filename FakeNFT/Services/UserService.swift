//  UserService.swift
//  FakeNFT
//  Created by Adam West on 12.11.2023.

import Foundation

typealias UserCompletion = (Result<User, Error>) -> Void

protocol UserService {
    func loadUser(id: String, completion: @escaping UserCompletion)
}

final class UserServiceImpl: UserService {

    private let networkClient: NetworkClient
    
    private let storage: UserStorage

    init(networkClient: NetworkClient, storage: UserStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadUser(id: String, completion: @escaping UserCompletion) {
        if let user = storage.getUser(with: id) {
            completion(.success(user))
            return
        }

        let request = UserRequest(id: id)
        networkClient.send(request: request, type: User.self) { [weak storage] result in
            switch result {
            case .success(let user):
                storage?.saveUser(user)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
