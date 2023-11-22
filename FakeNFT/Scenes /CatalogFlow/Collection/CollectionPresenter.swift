//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Руслан  on 07.11.2023.
//

import Foundation

protocol CollectionPresenterProtocol {
    var view: CollectionViewControllerProtocol! { get set }
    func viewDidLoad()
    func getAuthor() -> AuthorModel
    func getNftsCount() -> Int
    func getNftsIndex(_ index: Int, 
                      completion: @escaping (Result<CollectionCellModel, Error>) -> Void)
    func reverseLike(cell: CollectionCellProtocol, id: String)
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    private enum NftsError: Error {
        case indexOutOfBounds
    }
      
    // MARK: Public properties
    unowned var view: CollectionViewControllerProtocol!
        
    // MARK: Private properties
    private let networkClient: NetworkClient
    
    private let collections: CollectionModel
    
    private var profile: ProfileModel = ProfileModel(name: "", avatar: "", description: "", website: "", nfts: [], likes: [], id: "")
    private var author: AuthorModel = AuthorModel(name: "", description: "", website: "")
    private var nfts: [NftModel] = []
    
    private var collectionCell: [CollectionCellModel] = []
            
    private let loadGroup = DispatchGroup()
    
    // MARK: Initialization
    init(networkClient: NetworkClient = DefaultNetworkClient(), collections: CollectionModel) {
        self.networkClient = networkClient
        self.collections = collections
    }
    
    // MARK: Public methods
    func viewDidLoad() {
        view.showLoading()
        
        loadProfile()
        loadAuthor(collections.author)
        
        collections.nfts.forEach { [weak self] id in
            guard let self else { return }
            self.loadNfts(id) { nft in
                self.nfts.append(nft)
            }
        }
        self.loadGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            guard self.collections.nfts.count == self.nfts.count else {
                self.view.hideLoading()
                self.view.showAlertWithTime {
                    /// действие на кнопку "повторить"
                    self.nfts = []
                    self.collectionCell = []
                    self.viewDidLoad()
                }
                return
            }
            self.sortByName()
            self.createCollectionCellModel(profile: self.profile, nfts: self.nfts)
            self.view.hideLoading()
            self.view.updateCollectionView()
            self.view.setupCollection(self.collections)
        }
    }
    
    func getAuthor() -> AuthorModel {
        author
    }
    
    func getNftsIndex(_ index: Int, completion: @escaping (Result<CollectionCellModel, Error>) -> Void) {
        guard index < collectionCell.count else {
            completion(.failure(NftsError.indexOutOfBounds))
            return
        }
        let collectionCellModel = collectionCell[index]
        completion(.success(collectionCellModel))
    }
    
    func getNftsCount() -> Int {
        guard !collectionCell.isEmpty else { return 0 }
        return collectionCell.count
    }
    
    func reverseLike(cell: CollectionCellProtocol, id: String) {
        if profile.likes.contains(where: {$0 == id}) {
            profile.likes.removeAll(where: {$0 == id})
        } else {
            profile.likes.append(id)
        }
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
            self.networkClient.send(request: PutProfileRequest(profile: self.profile),
                               type: ProfileModel.self,
                               completionQueue: .main) { result in
                switch result {
                case .success(let profile):
                    cell.setIsLiked(isLiked: profile.likes.contains(id))
                case .failure(let error):
                    print("Не удалось выполнить reverseLike:", error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: Private methods
    private func createCollectionCellModel(profile: ProfileModel, nfts: [NftModel]) {
        nfts.forEach { nft in
            let collectionCellModel = CollectionCellModel(
                id: nft.id,
                name: nft.name,
                image: nft.images[0], /// первая картинка
                isLiked: profile.likes.contains(nft.id),
                isInCart: profile.nfts.contains(nft.id),
                rating: nft.rating,
                price: nft.price
            )
            self.collectionCell.append(collectionCellModel)
        }
    }
    
    private func sortByName() {
        self.nfts.sort { (x, y) -> Bool in
            return x.name.localizedCaseInsensitiveCompare(y.name) == .orderedAscending
        }
    }
    
    private func loadProfile() {
        self.loadGroup.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.networkClient.send(request: GetProfileRequest(),
                                    type: ProfileModel.self,
                                    completionQueue: .main,
                                    onResponse: { result in
                    defer {
                        self.loadGroup.leave()
                    }
                    switch result {
                    case .success(let profile):
                        self.profile = profile
                    case .failure(let error):
                        print("Не удалось выполнить загрузку профиля:", error.localizedDescription)
                    }
            })
        }
    }
    
    private func loadAuthor(_ id: String) {
        self.loadGroup.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.networkClient.send(request: GetAuthorRequest(id: id),
                                    type: AuthorModel.self,
                                    completionQueue: .main,
                                    onResponse: { result in
                defer {
                    self.loadGroup.leave()
                }
                switch result {
                case .success(let author):
                    self.author = author
                case .failure(let error):
                    print("Не удалось выполнить загрузку автора \(id):", error.localizedDescription)
                }
            })
        }
    }

    private func loadNfts(_ id: String, completion: @escaping (NftModel) -> Void) {
        self.loadGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            self.networkClient.send(request: GetNftsRequest(id: id),
                                    type: NftModel.self,
                                    completionQueue: .main,
                                    onResponse: { result in
                defer {
                    self.loadGroup.leave()
                }
                switch result {
                case .success(let model):
                    completion(model)
                case .failure(let error):
                    print("Не удалось выполнить загрузку nft \(id):", error.localizedDescription)
                }
            })
        }
    }
}
