//
//  MyNFTLabel.swift
//  FakeNFT
//
//  Created by Adam West on 04.11.2023.
//

import Foundation

import UIKit

final class MyNFTLabel: UILabel {
    // MARK: Private properties
    private let labelType: MyNFTLabelType
    
    // MARK: Initialisation
    init(labelType: MyNFTLabelType, text: String?) {
        self.labelType = labelType
        super.init(frame: .zero)
        self.text = text
        switchTypeOfLabelType(labelType)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    private func switchTypeOfLabelType(_ label: MyNFTLabelType) {
        switch label {
        case .big:
            self.textColor = .label
            self.font = .systemFont(ofSize: 17, weight: .bold)
        case .middle:
            self.textColor = .label
            self.font = .systemFont(ofSize: 15, weight: .regular)
        case .little:
            self.textColor = .label
            self.font = .systemFont(ofSize: 13, weight: .regular)
        }
    }
}
