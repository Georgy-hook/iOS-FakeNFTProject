//
//  AppNumberFormatter.swift
//  FakeNFT
//
//  Created by Georgy on 15.11.2023.
//

import Foundation

class AppNumberFormatter {
    static let shared = AppNumberFormatter()

    private init() {}

    private lazy var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    func formatPrice(_ price: Float) -> String? {
        return priceFormatter.string(from: NSNumber(value: price))
    }
}

