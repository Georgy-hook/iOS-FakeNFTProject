//  ProfileViewController.swift
//  Profile
//  Created by Adam West on 03.11.2023.

import UIKit

protocol InterfaceProfileViewController: AnyObject {
    func configureDataProfile(image: String?, name: String?, description: String?, website: String?)
}

final class ProfileViewController: UIViewController {
    // MARK: Private properties
    private var myNFT = [1,2,3]
    private var favoritesNFT = [1,2]
    
    private lazy var titleRows = [
        "Мои NFT (\(myNFT.count))",
        "Избранные NFT (\(favoritesNFT.count))",
        "О разработчике"
        ]
    
    // MARK: UI
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImagesAssets.profileImage.rawValue)
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Joaquin Phoenix"
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайт. Открыт к коллаборациям."
        label.setLineSpacing(lineSpacing: 5)
        return label
    }()
    private lazy var websiteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Joaquin Phoenix.com", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.addTarget(self, action: #selector(goToWebSite), for: .touchUpInside)
        return button
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: Delegate
    weak var delegateToEditing: InterfaceProfileViewController?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: Methods
    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navigationController?.navigationBar.prefersLargeTitles = true
            let editItem = UIBarButtonItem(image: UIImage(named: ImagesAssets.editButton.rawValue), style: .plain, target: self, action: #selector(editProfileData))
            editItem.tintColor = .black
            navBar.topItem?.setRightBarButton(editItem, animated: true)
            
        }
    }
    private func showWebViewController(with URLString: String) {
        let webViewerController = WebViewerController(urlString: URLString)
        let navigationController = UINavigationController(rootViewController: webViewerController)
        present(navigationController, animated: true)
    }
    private func showMyNFTViewController() {
        let myNFTViewController = MyNFTViewController()
        myNFTViewController.title = "Мои NFT"
        let navigationController = UINavigationController(rootViewController: myNFTViewController)
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.shadowImage = UIImage()
        present(navigationController, animated: true)
    }
    
    // MARK: Selectors
    @objc private func editProfileData() {
        let viewController = EditingProfileViewController()
        delegateToEditing = viewController
        delegateToEditing?.configureDataProfile(image: ImagesAssets.profileImage.rawValue, name: nameLabel.text, description: descriptionLabel.text, website: websiteButton.title(for: .normal))
        present(viewController, animated: true)
    }
    @objc private func goToWebSite() {
        showWebViewController(with: "https://\(String(describing: websiteButton.titleLabel?.text))")
    }
}

extension ProfileViewController {
    func updateDataProfile(image: String?, name: String?, description: String?, website: String?) {
        avatarImageView.image = UIImage(named: image ?? String())
        nameLabel.text = name
        descriptionLabel.text = description
        websiteButton.setTitle(website, for: .normal)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProfileViewController: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleRows.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titleRows[indexPath.row]
        cell.textLabel?.textColor = .label
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.accessoryType = UITableViewCell.AccessoryType.none
        let sentImage = UIImage(named: ImagesAssets.chevron.rawValue)
        let sentImageView = UIImageView(image: sentImage)
        sentImageView.frame = CGRect(x: 0, y: 0, width: 7.977, height: 13.859)
        cell.accessoryView = sentImageView
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0: showMyNFTViewController()
        case 1: print(2)
        case 2: goToWebSite()
        default: return
        }
    }
}

// MARK: - Setup views, constraints
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(avatarImageView, nameLabel, descriptionLabel, websiteButton, tableView)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 70),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: websiteButton.topAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }
}
