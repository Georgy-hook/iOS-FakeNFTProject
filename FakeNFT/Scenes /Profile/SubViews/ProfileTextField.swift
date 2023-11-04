//  ProfileTextField.swift
//  Profile
//  Created by Adam West on 03.11.2023.

import UIKit

final class ProfileTextField: UITextField {
    // MARK: Private properties
    private let textFieldType: TextFieldType
    
    // MARK: Initialisation
    init(fieldType: TextFieldType) {
        self.textFieldType = fieldType
        super.init(frame: .zero)
        configureTextField()
        switchTypeOfTextField(fieldType)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    private func configureTextField() {
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 12
        self.returnKeyType = .done
        self.autocorrectionType = .yes
        self.autocapitalizationType = .sentences
        self.leftViewMode = .always
        self.textColor = .label
        self.sizeToFit()
        self.font = .systemFont(ofSize: 17, weight: .regular)
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.size.height))
    }
    private func switchTypeOfTextField(_ textField: TextFieldType) {
        switch textField {
        case .userName:
            self.placeholder = "Введите ваше имя"
        case .description:
            self.placeholder = "Введите ваше описание"
        case .website:
            self.placeholder = "Введите ваш сайт"
            self.keyboardType = .emailAddress

        }
    }
}


