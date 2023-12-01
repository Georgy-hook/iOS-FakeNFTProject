//
//  PaymentViewPresenter.swift
//  FakeNFT
//
//  Created by Georgy on 07.11.2023.
//

import Foundation

// MARK: - Error
enum PaymentError: Error {
    case failedPayment
}

// MARK: - State

enum PaymentViewState {
    case initial, loading, failed(Error), data(CurrencyModel)
}

// MARK: - Protocol

protocol PaymentViewPresenter {
    func viewDidLoad()
    func didPayButtonTapped()
}

final class PaymentViewPresenterImpl: PaymentViewPresenter{
    // MARK: - Properties
    weak var view: PaymentView?
    private let service: CurrencyService
    private let cartService: CartService
    private var state = PaymentViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    private var profileID:String = "1"
    
    // MARK: - Init

    init(service: CurrencyService, cartService: CartService) {
        self.service = service
        self.cartService = cartService
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
        case is PaymentError:
            message = NSLocalizedString("Error.payment", comment: "")
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
    
    func didPayButtonTapped(){
        service.checkPaymentResult(with: profileID){ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let paymentResult):
                    if paymentResult.success {
                        view?.showPaymentResultVC()
                        removeAllItemsFromCart()
                    } else {
                        let errorModel = makeErrorModel(PaymentError.failedPayment)
                        view?.showCancelableError(errorModel)
                    }
                case .failure(let error):
                    self.state = .failed(error)
                }
        }
    }
    
    private func removeAllItemsFromCart(){
        cartService.removeFromCart(id: profileID, nfts: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
}
