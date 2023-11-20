//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import Foundation

protocol CatalogPresenterProtocol: Sortable {
    var view: CatalogViewControllerProtocol! { get set }
    var collectionsCount: Int { get }
    func viewDidLoad()
    func getCollectionIndex(_ index: Int) -> CollectionModel?
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: Public properties
    unowned var view: CatalogViewControllerProtocol!
    
    var collectionsCount: Int {
        return collections.count
    }
    
    // MARK: Private properties
    private let interactor: CatalogInteractorProtocol
    private let sortingSaveService: SortingSaveServiceProtocol
    
    private var collections: [CollectionModel] = []
    
    // MARK: Init
    init(interactor: CatalogInteractorProtocol,
         sortingSaveService: SortingSaveServiceProtocol = SortingSaveService(screen: .catalogue)) {
        self.interactor = interactor
        self.sortingSaveService = sortingSaveService
    }
       
    // MARK: Public methods
    func viewDidLoad() {
        view.showLoading()
        loadCollection()
    }
    
    func getCollectionIndex(_ index: Int) -> CollectionModel? {
        collections[index]
    }
     
    // MARK: Private methods
    private func loadCollection() {
        interactor.loadCollections { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.collections = model
                    self.sort(param: (self.sortingSaveService.savedSorting))
                    self.view.updateTableView()
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.view.hideLoading()
                self.view.endRefreshing()
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
