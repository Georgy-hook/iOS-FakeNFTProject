//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Руслан  on 07.11.2023.
//

import Foundation

protocol CollectionPresenterProtocol {
    var view: CollectionViewControllerProtocol? { get set }
    func viewDidLoad()
    func getAuthor() -> AuthorModel
    func getNftsCount() -> Int
    func getNftsIndex(_ index: Int, 
                      completion: @escaping (Result<NftsModel, Error>) -> Void)
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    private enum NftsError: Error {
        case indexOutOfBounds
    }
      
    // MARK: Public properties
    weak var view: CollectionViewControllerProtocol?
    
    var isCollectionLoadError = false
    
    // MARK: Private properties
    private let networkClient: NetworkClient
    
    private var profile: ProfileModel?
    private var nfts: [NftsModel] = []
    private var author: AuthorModel = AuthorModel(name: "", description: "", website: "")
    private var collections: CollectionModel
    //private var order: OrderModel = OrderModel(nfts: [])
            
    private let loadGroup = DispatchGroup()
    private let group = DispatchGroup()
    
    // MARK: Init
    init(networkClient: NetworkClient = DefaultNetworkClient(), collections: CollectionModel) {
        self.networkClient = networkClient
        self.collections = collections
    }
    
    // MARK: Public func
    func viewDidLoad() {
        view?.showLoading()
        
        loadAuthor(collections.author)
        
        collections.nfts.forEach { [weak self] id in
            guard let self = self else { return }
            group.enter()
            self.loadNfts(id) { nft in
                self.nfts.append(nft)
                self.group.leave()
            }
        }
        /// как завершится вся группа
        group.notify(queue: .main) {
            self.sortByName()
            print("Загрузка loadNfts завершена")
            
            /// после завершения всех loadNfts
            self.loadGroup.notify(queue: .main) {
                print("Обновляю UI")
                self.view?.hideLoading()
                self.view?.updateCollectionView()
                self.view?.setupCollection(self.collections)
            }
        }
    }
    
    func getAuthor() -> AuthorModel {
        author
    }
    
    func getNftsIndex(_ index: Int, completion: @escaping (Result<NftsModel, Error>) -> Void) {
        guard index < nfts.count else {
            completion(.failure(NftsError.indexOutOfBounds))
            return
        }
        let nftsModel = nfts[index]
        completion(.success(nftsModel))
    }
    
    func getNftsCount() -> Int {
        guard !nfts.isEmpty else {
            return 0
        }
        return nfts.count
    }
    
    // MARK: Private func
    private func sortByName() {
        self.nfts.sort { (x, y) -> Bool in
            return x.name.localizedCaseInsensitiveCompare(y.name) == .orderedAscending
        }
    }
    
    private func loadAuthor(_ id: String) {
        self.loadGroup.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.networkClient.send(request: GetAuthorRequest(id: id),
                                    type: AuthorModel.self,
                                    onResponse: { result in
                DispatchQueue.main.async {
                    defer {
                        self.loadGroup.leave()
                    }
                    switch result {
                    case .success(let author):
                        self.author = author
                    case .failure(_):
                        self.isCollectionLoadError = true
                    }
                }
            })
        }
    }

    private func loadNfts(_ nftsId: String, completion: @escaping (NftsModel) -> Void) {
        self.loadGroup.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.networkClient.send(request: GetNftsRequest(nftsId: nftsId),
                                    type: NftsModel.self,
                                    onResponse: { result in
                DispatchQueue.main.async {
                    defer {
                        self.loadGroup.leave()
                    }
                    switch result {
                    case .success(let model):
                        completion(model)
                    case .failure(_):
                        self.isCollectionLoadError = true
                    }
                }
            })
        }
    }
    
    private func loadProfile() {
        self.loadGroup.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.networkClient.send(request: GetProfileRequest(),
                                    type: ProfileModel.self,
                                    onResponse: { result in
                DispatchQueue.main.async {
                    defer {
                        self.loadGroup.leave()
                    }
                    switch result {
                    case .success(let profile):
                        self.profile = profile
                    case .failure(_):
                        self.isCollectionLoadError = true
                    }
                }
            })
        }
    }
}
