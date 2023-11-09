//  ProfileViewController.swift
//  Profile
//  Created by Adam West on 03.11.2023.

import UIKit
import Kingfisher

protocol InterfaceProfileViewController: AnyObject {
    var presenter: InterfaceProfilePresenter { get set }
    func reloadTable()
    func showErrorAlert()
}

final class ProfileViewController: UIViewController & InterfaceProfileViewController {
    // MARK: Private properties
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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

    private let websiteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemBlue
        label.lineBreakMode = .byClipping
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
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
    
    // MARK: Initialisation
    init() {
        self.presenter = ProfilePresenter()
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Presenter
    var presenter: InterfaceProfilePresenter
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
        setupNavigationBar()
        updateDataProfile()
    }
    
    // MARK: Methods
    private func updateDataProfile() {
        presenter.setupDataProfile() { [weak self] profile in
            guard let profile else { return }
            guard let self else { return }
            self.updateAvatar(with: profile.avatar)
            self.nameLabel.text = profile.name
            self.descriptionLabel.text = profile.description
            self.websiteLabel.text = profile.website
        }
    }
    //MARK: - KingFisher
    func updateAvatar(with url: String) {
        let cache = ImageCache.default
        cache.clearDiskCache()
        avatarImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 60)
        avatarImageView.kf.setImage(with: URL(string: url),
                                    placeholder: UIImage(named: "placeholder"),
                                    options: [.processor(processor),  .transition(.fade(1))])
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    func showErrorAlert() {
        self.showErrorLoadAlert()
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
    
    private func goToWebSite() {
        showWebViewController(with: websiteLabel.text ?? String())
    }
    
    private func showWebViewController(with URLString: String) {
        let webViewerController = WebViewerController(urlString: URLString)
        let navigationController = UINavigationController(rootViewController: webViewerController)
        present(navigationController, animated: true)
    }
    
    private func showMyNFTViewController() {
        let myNFTViewController = MyNFTViewController()
        presenter.setupDelegateMyNFT(viewController: myNFTViewController)
        myNFTViewController.title = "Мои NFT"
        let navigationController = UINavigationController(rootViewController: myNFTViewController)
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func showFavouriteNFTViewController() {
        let favouriteNFTViewController = FavouriteNFTViewController()
        presenter.setupDelegateFavouriteNFT(viewController: favouriteNFTViewController)
        favouriteNFTViewController.title = "Избранные NFT"
        let navigationController = UINavigationController(rootViewController: favouriteNFTViewController)
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func showEditingProfileViewController() {
        let viewController = EditingProfileViewController()
        presenter.setupDelegateEditingProfile(viewController: viewController, image: avatarImageView.image?.toPngString(), name: nameLabel.text, description: descriptionLabel.text, website: websiteLabel.text)
        present(viewController, animated: true)
    }
    
    // MARK: Selectors
    @objc private func editProfileData() {
        showEditingProfileViewController()
    }
}

// MARK: Update data profile editingVC
extension ProfileViewController {
    func updateDataProfile(image: String?, name: String?, description: String?, website: String?) {
        avatarImageView.image = image?.toImage()
        nameLabel.text = name
        descriptionLabel.text = description
        websiteLabel.text = website
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProfileViewController: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.titleRows.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = presenter.titleRows[indexPath.row]
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
extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(stackView, descriptionLabel, websiteLabel, tableView)
        stackView.addSubviews(avatarImageView, nameLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            avatarImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }
}
