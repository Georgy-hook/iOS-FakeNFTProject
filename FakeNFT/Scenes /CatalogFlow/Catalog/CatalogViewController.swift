//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Руслан  on 04.11.2023.
//

import UIKit
import ProgressHUD

protocol CatalogViewControllerProtocol: AnyObject & LoadingView & ErrorView {
    var presenter: CatalogPresenterProtocol { get set }
    func updateTableView()
    func endRefreshing()
}

final class CatalogViewController: UIViewController {
    
    // MARK: Public properties
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: Presenter
    var presenter: CatalogPresenterProtocol
    
    // MARK: Private properties
    private let router: CatalogRouter
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.refreshControl = refreshControl
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return view
    }()
    
    // MARK: Initialization
    init(presenter: CatalogPresenterProtocol, router: CatalogRouter) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // MARK: Private methods
    private func scrollToTop() {
        let indexPath = IndexPath(row: .zero, section: .zero)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func sortAndUpdate(param: Sort) {
        presenter.sort(param: param)
        tableView.reloadData()
        scrollToTop()
    }
    
    // MARK: Selectors
    @objc 
    private func refreshData() {
        refreshControl.beginRefreshing()
        presenter.viewDidLoad()
    }
    
    @objc
    private func sortButtonTapped() {
        let controller = UIAlertController(title: Constants.Strings.alertTitle, message: nil, preferredStyle: .actionSheet)
        controller.addAction(.init(title: Constants.Strings.alertByNameAction, style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.sortAndUpdate(param: .NFTName)
        }))
        controller.addAction(.init(title: Constants.Strings.alertByCountAction, style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.sortAndUpdate(param: .NFTCount)
        }))
        controller.addAction(.init(title: Constants.Strings.alertCancelAction, style: .cancel))
        present(controller, animated: true)
    }
}

// MARK: - CatalogViewControllerProtocol
extension CatalogViewController: CatalogViewControllerProtocol {
    func updateTableView() {
        tableView.reloadData()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Layout.cellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collection = presenter.getCollectionIndex(indexPath.row) else { return }
        router.showCollection(for: self, animated: true, collectionModel: collection)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let collection = presenter.getCollectionIndex(indexPath.row) else { return nil }
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return nil }
            
            let menu = UIMenu(title: "\(collection.name)", children: [
                UIAction(title: Constants.Strings.uiMenuOpen, handler: { action in
                    self.router.showCollection(for: self, animated: true, collectionModel: collection)
                })
            ])
            return menu
        }
        return configuration
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
        view.backgroundColor = Constants.Colors.backgroundColor
        view.addSubviews(tableView, activityIndicator)
    }
    
    func setupSortButton() {
        let sortImage = UIImage(named: Constants.ImageNames.sortImage) ?? UIImage(systemName: Constants.ImageNames.systemSortImage)
        let sortButton = UIBarButtonItem(image: sortImage, style: .done, target: self, action: #selector(sortButtonTapped))
        sortButton.tintColor = Constants.Colors.tintColor
        navigationItem.rightBarButtonItem = sortButton
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.backgroundColor = Constants.Colors.clear
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
    enum Constants {
        enum Layout {
            static let cellHeight: CGFloat = 187
        }

        enum Strings {
            static let alertTitle = "Сортировка"
            static let alertCancelAction = "Закрыть"
            static let alertByNameAction = "По названию"
            static let alertByCountAction = "По количеству NFT"
            
            static let uiMenuOpen = "Открыть"
        }

        enum ImageNames {
            static let sortImage = "sort"
            static let systemSortImage = "line.3.horizontal"
        }
        
        enum Colors {
            static let backgroundColor = UIColor.background
            static let tintColor = UIColor.segmentActive
            static let clear = UIColor.clear
        }
    }
}
