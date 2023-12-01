//
//  CurrencyByldRequest.swift
//  FakeNFT
//
//  Created by Georgy on 08.11.2023.
//

import Foundation

struct CurrencyRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
