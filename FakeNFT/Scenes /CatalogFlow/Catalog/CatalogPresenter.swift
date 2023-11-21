//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import Foundation

protocol CatalogPresenterProtocol: Sortable {
    var view: CatalogViewControllerProtocol! { get set }
    func viewDidLoad()
    var collectionsCount: Int { get }
    func getCollectionIndex(_ index: Int) -> CollectionModel?
}

final class CatalogPresenter {
    
    // MARK: Public properties
    unowned var view: CatalogViewControllerProtocol!
    
    // MARK: Private properties
    private let interactor: CatalogInteractorProtocol
    private let sortingSaveService: SortingSaveServiceProtocol
    
    private var collections: [CollectionModel] = []
    
    // MARK: Initialization
    init(interactor: CatalogInteractorProtocol,
         sortingSaveService: SortingSaveServiceProtocol = SortingSaveService(screen: .catalogue)) {
        self.interactor = interactor
        self.sortingSaveService = sortingSaveService
    }
     
    // MARK: Private methods
    private func loadCollection() {
        DispatchQueue.global().async {
            self.interactor.loadCollections { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let model):
                    self.collections = model
                    self.sort(param: (self.sortingSaveService.savedSorting))
                    self.view.updateTableView()
                case .failure(let error):
                    view.showError(ErrorModel(message: "Ошибка сервера", actionText: "Повторить", action: {
                        self.viewDidLoad()
                    }))
                    print(error.localizedDescription)
                }
                self.view.hideLoading()
                self.view.endRefreshing()
            }
        }
    }
}

// MARK: - CatalogPresenterProtocol
extension CatalogPresenter: CatalogPresenterProtocol {
    var collectionsCount: Int {
        return collections.count
    }
    
    func viewDidLoad() {
        view.showLoading()
        loadCollection()
    }
    
    func getCollectionIndex(_ index: Int) -> CollectionModel? {
        collections[index]
    }
}

//MARK: - Sorting
extension CatalogPresenter {
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
