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
    
    var activityIndicator: UIActivityIndicatorView
    var presenter: CatalogPresenterProtocol
    
    private lazy var refreshControl: UIRefreshControl = {
           let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
           return refreshControl
       }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
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
        setupPullToRefresh()
    }

    private func setupPullToRefresh() {
        tableView.refreshControl = refreshControl
    }
        
    func updateTableView() {
        tableView.reloadData()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    // MARK: Selectors
    @objc 
    private func refreshData() {
        refreshControl.beginRefreshing()
        presenter.viewDidLoad()
    }
    
    @objc
    private func sortButtonTapped() {
        // TODO: Доделать сортировку
        let controller = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        controller.addAction(.init(title: "По названию", style: .default, handler: { /*[weak self]*/ _ in
            print("")
        }))
        controller.addAction(.init(title: "По количеству NFT", style: .default, handler: { /*[weak self]*/ _ in
            print("")
        }))
        controller.addAction(.init(title: "Закрыть", style: .cancel))
        present(controller, animated: true)
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collections = presenter.getCollectionsIndex(indexPath.row) else { return }
        
        let collectionPresenter = CollectionPresenter()
        let collectionViewController = CollectionViewController(presenter: collectionPresenter)
        
        collectionViewController.setupCollections(collections)
        collectionViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(collectionViewController, animated: true)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collectionsCount = presenter.collectionsCount
        return collectionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.identifier, for: indexPath) as? CatalogCell else {
            return UITableViewCell()
        }        
        setupCell(cell, indexPath)
        return cell
    }
    
    private func setupCell(_ cell: CatalogCell, _ indexPath: IndexPath) {
        guard let collections = presenter.getCollectionsIndex(indexPath.row) else { return }
        cell.setupCell(collections)
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
        navigationController?.hidesBarsOnSwipe = true
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
