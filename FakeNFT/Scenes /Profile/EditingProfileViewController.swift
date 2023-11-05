//  EditingProfileViewController.swift
//  Profile
//  Created by Adam West on 03.11.2023.

import UIKit

final class  EditingProfileViewController: UIViewController {
    // MARK: Private properties
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .black
        button.setImage(UIImage(named: ImagesAssets.close.rawValue), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Сменить фото", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loadPhoto), for: .touchUpInside)
        return button
    }()
    private let loadLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Загрузить изображение"
        label.isHidden = true
        return label
    }()
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 12
        textView.returnKeyType = .done
        textView.autocorrectionType = .yes
        textView.autocapitalizationType = .sentences
        textView.textAlignment = .left
        textView.textColor = .label
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 16)
        return textView
    }()
    private let limitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .red
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let nameLabel = ProfileLabel(labelType: .userName)
    private let descriptionLabel = ProfileLabel(labelType: .description)
    private let websiteLabel = ProfileLabel(labelType: .website)
    
    private let nameTextField = ProfileTextField(fieldType: .userName)
    private let websiteTextField = ProfileTextField(fieldType: .website)
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        _ = hideKeyboardWhenClicked
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateDataProfile()
    }
    
    // MARK: Methods
    func updateDataProfile() {
        guard let tabBarController = presentingViewController as? TabBarController else { return }
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return }
        guard let profileViewController = navigationController.viewControllers.first(where: { $0.isKind(of: ProfileViewController.self) }) as? ProfileViewController else { return }
        profileViewController.updateDataProfile(image: avatarImageView.image?.toPngString(), name: nameTextField.text, description: descriptionTextView.text, website: websiteTextField.text)
        
    }
    
    // MARK: Selectors
    @objc private func goBack() {
        updateDataProfile()
        dismiss(animated: true)
    }
    @objc private func loadPhoto() {
        loadLabel.isHidden = false
    }
}

// MARK: - InterfaceProfileViewController
extension EditingProfileViewController: InterfaceProfileViewController {
    func configureDataProfile(image: String?, name: String?, description: String?, website: String?) {
        avatarImageView.image = image?.toImage()
        nameTextField.text = name
        descriptionTextView.text = description
        websiteTextField.text = website
    }
}

// MARK: - UITextViewDelegate
extension EditingProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите ваше описание"
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 138
    }
}

// MARK: - UITextFieldDelegate
extension EditingProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        limitLabel.isHidden = true
        setupUI()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? String()
        guard let stringRange = Range(range, in: currentText) else {
            return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count >= 38 {
            limitLabel.isHidden = false
            newConstraints()
        } else {
            limitLabel.isHidden = true
            setupUI()
        }
        
        return updatedText.count <= 38
    }
}


// MARK: - Setup views, constraints
private extension EditingProfileViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, avatarImageView, changePhotoButton,
                         loadLabel, nameLabel, descriptionLabel, websiteLabel,
                         nameTextField, descriptionTextView, websiteTextField, limitLabel)
        
        nameTextField.delegate = self
        websiteTextField.delegate = self
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            
            changePhotoButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: 12),
            changePhotoButton.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 23),
            changePhotoButton.widthAnchor.constraint(equalToConstant: 45),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 24),
            
            loadLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 15),
            loadLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 174),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),

            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            websiteTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
        ])
    }
    private func newConstraints() {
        setupUI()
        NSLayoutConstraint.activate([
            limitLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 6),
            limitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
