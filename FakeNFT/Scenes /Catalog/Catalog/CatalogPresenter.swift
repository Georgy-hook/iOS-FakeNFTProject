//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import Foundation

protocol CatalogPresenterProtocol: Sortable {
    var view: CatalogViewControllerProtocol? { get set }
    var collectionsCount: Int { get }
    func viewDidLoad()
    func getCollectionsIndex(_ index: Int) -> CollectionModel?
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    weak var view: CatalogViewControllerProtocol?
    
    var collectionsCount: Int {
        return collections.count
    }
    
    private let sortingSaveService: SortingSaveServiceProtocol
    private let networkClient: NetworkClient
    
    private var collections: [CollectionModel] = []
    
    init(networkClient: NetworkClient = DefaultNetworkClient(),
         sortingSaveService: SortingSaveServiceProtocol = SortingSaveService(screen: .catalogue)) {
        self.networkClient = networkClient
        self.sortingSaveService = sortingSaveService
    }
            
    func getCollectionsIndex(_ index: Int) -> CollectionModel? {
        collections[index]
    }
        
    func viewDidLoad() {
        view?.showLoading()
        loadCollection()
    }
    
    private func loadCollection() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.networkClient.send(request: GetCollectionsRequest(), type: [CollectionModel].self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        assert(Thread.isMainThread)
                        self.collections = model
                        self.sort(param: (self.sortingSaveService.savedSorting))
                        self.view?.updateTableView()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self.view?.hideLoading()
                    self.view?.endRefreshing()
                }
            }
        }
    }
}

//MARK: - Sorting
extension CatalogPresenter: Sortable {
    func sort(param: Sort) {
        sortingSaveService.saveSorting(param: param)
        switch param {
        case .NFTCount:
            collections = collections.sorted(by: { $0.nfts.count > $1.nfts.count })
        case .NFTName:
            collections = collections.sorted(by: { $0.name < $1.name })
        }
    }
}
