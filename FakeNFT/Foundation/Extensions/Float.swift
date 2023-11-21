//  Float.swift
//  FakeNFT
//  Created by Adam West on 15.11.2023.

import Foundation

extension Float {
    static var numberFormatter: NumberFormatter =  {
        let numberFormatter: NumberFormatter = .init()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    // MARK: Added custom format to Float
    func formatPrice() -> String {
        guard let formatString = Float.numberFormatter.string(from: NSNumber(value: self)) else {
            return String()
        }
        return formatString
    }
}
