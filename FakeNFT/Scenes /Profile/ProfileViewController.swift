//  ProfileViewController.swift
//  Profile
//  Created by Adam West on 03.11.2023.

import UIKit
import Kingfisher

protocol InterfaceProfileViewController: AnyObject {
    func configureDataProfile(image: String?, name: String?, description: String?, website: String?)
}
protocol InterfaceMyNFTViewController: AnyObject {
    var myNFT: [String] { get set }
    var favoritesNFT: [String] { get set }
}
protocol InterfaceFavouriteNFTViewController: AnyObject {
    var favoritesNFT: [String] { get set }
}

final class ProfileViewController: UIViewController {
    // MARK: Private properties
    private let gradientLayer = GradientLayer()
    private let profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), profileStorage: ProfileStorageImpl())
    
    private var myNFT = [String]()
    private var favoritesNFT = [String]()
    private var dataProfile: Profile = Profile()
    
    private lazy var titleRows: [String] = [
        "Мои NFT (\(myNFT.count))",
        "Избранные NFT (\(favoritesNFT.count))",
        "О разработчике"
    ]
    
    // MARK: UI
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setLineSpacing(lineSpacing: 5)
        return label
    }()
    private lazy var websiteButton: UIButton = {
        let button = UIButton()
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
    
    // MARK: Delegates
    weak var delegateToEditing: InterfaceProfileViewController?
    weak var delegateToMyNFT: InterfaceMyNFTViewController?
    weak var delegateToFavouriteNFT: InterfaceFavouriteNFTViewController?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupDataProfile()
        addGradient()
    }
    
    // MARK: Setup Network data
    private func setupDataProfile() {
        profileService.loadProfile(id: "1") { result in
            switch result {
            case .success(let profile):
                self.myNFT = profile.nfts
                self.favoritesNFT = profile.likes
                self.updateAvatar(with: profile.avatar)
                self.nameLabel.text = profile.name
                self.descriptionLabel.text = profile.description
                self.websiteButton.setTitle(profile.website, for: .normal)
            case .failure(let error):
                print(error)
            }
        }
    }
    //MARK: - KingFisher
    func updateAvatar(with url: String) {
        let cache = ImageCache.default
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 60)
        avatarImageView.kf.setImage(with: URL(string: url),
                                    placeholder: UIImage(named: "placeholder"),
                                    options: [.processor(processor),  .transition(.fade(2))],
                                    completionHandler: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.gradientLayer.removeFromSuperLayer(views: [self.avatarImageView, self.nameLabel, self.descriptionLabel, self.websiteButton])
                self.titleRows = [
                    "Мои NFT (\(self.myNFT.count))",
                    "Избранные NFT (\(self.favoritesNFT.count))",
                    "О разработчике"
                ]
                self.tableView.reloadData()
            case .failure(let error):
                print("\(error)")
            }
        })
    }
    
    // MARK: Setup ViewControllers
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
        delegateToMyNFT = myNFTViewController
        delegateToMyNFT?.myNFT = myNFT
        delegateToMyNFT?.favoritesNFT = favoritesNFT
        myNFTViewController.title = "Мои NFT"
        let navigationController = UINavigationController(rootViewController: myNFTViewController)
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func showFavouriteNFTViewController() {
        let favouriteNFTViewController = FavouriteNFTViewController()
        delegateToFavouriteNFT = favouriteNFTViewController
        delegateToFavouriteNFT?.favoritesNFT = favoritesNFT
        favouriteNFTViewController.title = "Избранные NFT"
        let navigationController = UINavigationController(rootViewController: favouriteNFTViewController)
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func showEditingProfileViewController() {
        let viewController = EditingProfileViewController()
        delegateToEditing = viewController
        delegateToEditing?.configureDataProfile(image: avatarImageView.image?.toPngString(), name: nameLabel.text, description: descriptionLabel.text, website: websiteButton.title(for: .normal))
        present(viewController, animated: true)
    }
    
    // MARK: Gradient Layer
    private func addGradient() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            DispatchQueue.main.sync {
                self.gradientLayer.gradientLayer(view: self.avatarImageView, width: 70, height: 70, cornerRadius: 35)
                self.gradientLayer.gradientLayer(view: self.nameLabel, width: self.view.bounds.width - 48.0 - 70, height: 30, cornerRadius: 5)
                self.gradientLayer.gradientLayer(view: self.websiteButton, width: self.view.bounds.width - 32.0, height: 30, cornerRadius: 5)
            }
        }
    }
    
    // MARK: Selectors
    @objc private func editProfileData() {
        showEditingProfileViewController()
    }
    @objc private func goToWebSite() {
        showWebViewController(with: websiteButton.titleLabel?.text ?? String())
    }
}

// MARK: Update data profile Delegate
extension ProfileViewController {
    func updateDataProfile(image: String?, name: String?, description: String?, website: String?) {
        avatarImageView.image = image?.toImage()
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
        case 1: showFavouriteNFTViewController()
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
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
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
