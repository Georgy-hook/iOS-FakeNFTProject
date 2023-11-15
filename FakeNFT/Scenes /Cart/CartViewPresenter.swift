//
//  CartViewPresenter.swift
//  FakeNFT
//
//  Created by Georgy on 04.11.2023.
//

import Foundation

// MARK: - Protocol

protocol CartViewPresenter {
    func viewDidLoad()
    func makeSortModel()
    func didCellDeleteButtonTapped(with id:String)
    func returnButtonDidTapped()
    func deleteButtonDidTapped()
}

// MARK: - State

enum CartViewState {
    case initial, loading, failed(Error), data([Nft]), empty, delete
}

final class CartViewPresenterImpl: CartViewPresenter{
    // MARK: - Properties
    weak var view: CartView?
    private let service: CartService
    private var nfts: [Nft] = [] {
        didSet {
            view?.setTableView(with: nfts)
        }
    }
    private var state = CartViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    private var sortOption = SortOption.name {
        didSet {
            sort(with: sortOption)
        }
    }
    private var deletedID:String?
    private var profileID:String = "1"
    private let numberFormatter = AppNumberFormatter.shared
    
    // MARK: - Init
    
    init(service: CartService) {
        self.service = service
        if let savedSortOption = UserDefaults.standard.string(forKey: "SortOptionKey") {
            if let sortOption = SortOption(rawValue: savedSortOption) {
                self.sortOption = sortOption
            }
        }
    }
    
    // MARK: - Functions
    func viewDidLoad() {
        state = .loading
    }
    
    func makeSortModel(){
        view?.showSortOptions{ [weak self] sortOption in
            self?.sortOption = sortOption
            UserDefaults.standard.set(sortOption.rawValue, forKey: "SortOptionKey")
        }
    }
    
    func didCellDeleteButtonTapped(with id:String){
        state = .delete
        deletedID = id
    }
    
    func returnButtonDidTapped(){
        state = .data(nfts)
    }
    
    func deleteButtonDidTapped() {
        nfts.removeAll(where: {
            $0.id == deletedID
        })
        
        if nfts.isEmpty{
            state = .empty
        } else {
            state = .data(nfts)
        }
        
        service.removeFromCart(id: profileID, nfts: nfts){_ in }
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNfts()
        case .data(let nfts):
            view?.deleteStateChanged(with: true)
            view?.hideLoading()
            guard !nfts.isEmpty else {
                state = .empty
                return
            }
            let total = calculateTotalPrice(with: nfts)
            self.nfts = nfts
            sort(with: sortOption)
            view?.setPrice(with: total)
            view?.setCount(with: nfts.count)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        case .empty:
            view?.cartIsEmpty()
            view?.deleteStateChanged(with: true)
        case .delete:
            view?.deleteStateChanged(with: false)
        }
    }
    
    private func loadNfts(){
        service.loadNFTs(with: profileID){[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.state = .data(nfts)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
    
    private func calculateTotalPrice(with ntfs:[Nft]) -> String{
        var total:Float = 0.0
        ntfs.forEach{
            total += $0.price
        }
        guard let totalString = numberFormatter.formatPrice(total) else { return "0.0"}
        return totalString
    }
    
    private func sort(with sortOption: SortOption){
        switch sortOption {
        case .price:
            nfts = nfts.sorted { $0.price < $1.price }
        case .rating:
            nfts = nfts.sorted { $0.rating < $1.rating }
        case .name:
            nfts = nfts.sorted { $0.name < $1.name }
        }
    }
}
