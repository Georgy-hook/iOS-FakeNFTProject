//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Руслан  on 04.11.2023.
//

import UIKit
import ProgressHUD

protocol CatalogViewControllerProtocol: AnyObject & LoadingView {
    var presenter: CatalogPresenterProtocol { get set }
    func updateTableView()
    func endRefreshing()
}

final class CatalogViewController: UIViewController & CatalogViewControllerProtocol {
    
    // MARK: Public properties
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var presenter: CatalogPresenterProtocol
    
    // MARK: Private properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Init
    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
        self.presenter.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
     
    // MARK: Public methods
    func updateTableView() {
        tableView.reloadData()
    }
    
    // MARK: Public methods
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    private func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    // MARK: Selectors
    @objc 
    private func refreshData() {
        refreshControl.beginRefreshing()
        presenter.viewDidLoad()
    }
    
    @objc
    private func sortButtonTapped() {
        let controller = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        controller.addAction(.init(title: "По названию", style: .default, handler: { [weak self] _ in
            self?.presenter.sort(param: .NFTName)
            self?.tableView.reloadData()
            self?.scrollToTop()
        }))
        controller.addAction(.init(title: "По количеству NFT", style: .default, handler: { [weak self] _ in
            self?.presenter.sort(param: .NFTCount)
            self?.tableView.reloadData()
            self?.scrollToTop()
        }))
        controller.addAction(.init(title: "Закрыть", style: .cancel))
        present(controller, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight.rawValue
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collections = presenter.getCollectionIndex(indexPath.row) else { return }
        
        let collectionPresenter = CollectionPresenter(collections: collections)
        let collectionViewController = CollectionViewController(presenter: collectionPresenter)
        
        collectionViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(collectionViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.collectionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.identifier, for: indexPath) as? CatalogCell else {
            assertionFailure("Failed to dequeue CatalogCell for indexPath: \(indexPath)")
            return UITableViewCell()
        }        
        setupCell(cell, indexPath)
        return cell
    }
    
    private func setupCell(_ cell: CatalogCell, _ indexPath: IndexPath) {
        guard let collection = presenter.getCollectionIndex(indexPath.row) else { return }
        cell.setupCell(collection)
    }
}

// MARK: - Setup Views/Constraints
private extension CatalogViewController {
    func setupViews() {
        setupNavigationController()
        setupSortButton()
        view.backgroundColor = .background
        view.addSubviews(tableView, activityIndicator)
    }
    
    func setupSortButton() {
        let sortImage = UIImage(named: "sort") ?? UIImage(systemName: "line.3.horizontal")
        let sortButton = UIBarButtonItem(image: sortImage, style: .done, target: self, action: #selector(sortButtonTapped))
        sortButton.tintColor = .black
        navigationItem.rightBarButtonItem = sortButton
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - Constants
private extension CatalogViewController {
    enum Constants: CGFloat {
        case cellHeight = 187
    }
}
