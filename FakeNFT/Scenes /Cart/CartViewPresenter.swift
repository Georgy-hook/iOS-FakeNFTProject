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
}

// MARK: - State

enum CartViewState {
    case initial, loading, failed(Error), data([Nft]), empty
}

final class CartViewPresenterImpl: CartViewPresenter{
    // MARK: - Properties
    weak var view: CartView?
    private let service: CartService
    private var state = CartViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init

    init(service: CartService) {
        self.service = service
    }
    
    // MARK: - Functions
    func viewDidLoad() {
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNfts()
        case .data(let nfts):
            view?.hideLoading()
            guard !nfts.isEmpty else {
                state = .empty
                return
            }
            let total = calculateTotalPrice(with: nfts)
            view?.setTableView(with: nfts)
            view?.setPrice(with: total)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        case .empty:
            view?.cartIsEmpty()
        }
    }
    
    private func loadNfts(){
        service.loadNFTs(with: "1"){[weak self] result in
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
    
    private func calculateTotalPrice(with ntfs:[Nft]) -> Float{
        var total:Float = 0.0
        ntfs.forEach{
            total += $0.price
        }
        return total
    }
}
