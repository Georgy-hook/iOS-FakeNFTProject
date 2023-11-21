//  MyNFTViewController.swift
//  FakeNFT
//  Created by Adam West on 04.11.2023.

import UIKit

protocol InterfaceMyNFTController: AnyObject, LoadingView {
    var presenter: InterfaceMyNFTPresenter { get set }
    func reloadData()
    func showErrorAlert()
}

final class MyNFTViewController: UIViewController & InterfaceMyNFTController {
    // MARK: Public Properties
    var activityIndicator: UIActivityIndicatorView
    
    // MARK: Presenter
    var presenter: InterfaceMyNFTPresenter
    
    // MARK: Private properties
    private var emptyLabel = MyNFTLabel(labelType: .big, text: "У Вас еще нет NFT")

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(MyNFTCell.self)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        return tableView
    }()
    
    // MARK: Initialisation
    init(presenter: InterfaceMyNFTPresenter) {
        self.presenter = presenter
        self.emptyLabel.isHidden = true
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: Public methods
    func reloadData() {
        tableView.reloadData()
        showEmptyLabel()
    }
    func showErrorAlert() {
        self.showErrorLoadAlert()
    }
    
    // MARK: Private methods
    private func showEmptyLabel() {
        presenter.collectionsCount == 0 ? (emptyLabel.isHidden = false) : (emptyLabel.isHidden = true)
    }
    
    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            let editItem = UIBarButtonItem(image: UIImage(named: ImagesAssets.sort.rawValue), style: .plain, target: self, action: #selector(filterNFT))
            editItem.tintColor = .black
            navBar.topItem?.setRightBarButton(editItem, animated: true)
            
            let backItem = UIBarButtonItem(image: UIImage(named: ImagesAssets.backWard.rawValue), style: .plain, target: self, action: #selector(goBack))
            backItem.tintColor = .black
            navBar.topItem?.setLeftBarButton(backItem, animated: true)
        }
    }
    
    private func showFilterAlert() {
        let alert = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        let priceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            guard let self else { return }
            self.presenter.typeSorted(type: .price)
        }
        let raitingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
             guard let self else { return }
            self.presenter.typeSorted(type: .rating)
        }
        let nameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
             guard let self else { return }
            self.presenter.typeSorted(type: .name)
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(priceAction)
        alert.addAction(raitingAction)
        alert.addAction(nameAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func configureCell(with indexPath: IndexPath) -> UITableViewCell {
        let cell = presenter.configureCell(indexPath)
        return cell
    }
    
    // MARK: Selectors
    @objc private func filterNFT() {
        showFilterAlert()
    }
    @objc private func goBack() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MyNFTViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.collectionsCount
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(with: indexPath)
        return cell
    }
}

// MARK: - Setup views, constraints
private extension MyNFTViewController {
    func setupUI() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        view.addSubviews(tableView, emptyLabel, activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
