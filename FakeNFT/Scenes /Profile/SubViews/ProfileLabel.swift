//  ProfileLabel.swift
//  Profile
//  Created by Adam West on 03.11.2023.

import UIKit

final class ProfileLabel: UILabel {
    // MARK: Private properties
    private let labelType: LabelType
    
    // MARK: Initialisation
    init(labelType: LabelType) {
        self.labelType = labelType
        super.init(frame: .zero)
        configureLabelType()
        switchTypeOfLabelType(labelType)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    private func configureLabelType() {
        self.textColor = .label
        self.font = .systemFont(ofSize: 22, weight: .bold)
    }
    private func switchTypeOfLabelType(_ label: LabelType) {
        switch label {
        case .userName:
            self.text = "Имя"
        case .description:
            self.text = "Описание"
        case .website:
            self.text = "Сайт"
        }
    }
}
