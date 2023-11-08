//
//  PaymentViewPresenter.swift
//  FakeNFT
//
//  Created by Georgy on 07.11.2023.
//

import Foundation

// MARK: - State

enum PaymentViewState {
    case initial, loading, failed(Error), data(CurrencyModel)
}

// MARK: - Protocol

protocol PaymentViewPresenter {
    func viewDidLoad()
}

final class PaymentViewPresenterImpl: PaymentViewPresenter{
    // MARK: - Properties
    weak var view: PaymentView?
    private let service: CurrencyService
    private var state = PaymentViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init

    init(service: CurrencyService) {
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
            loadCurrencies()
        case .data(let currencies):
            view?.hideLoading()
            view?.setCollectionView(with: currencies)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
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
    
    func loadCurrencies(){
        service.loadCurrencies{ result in
            switch result{
            case .success(let currencies):
                self.state = .data(currencies)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
}
