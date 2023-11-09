//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Руслан  on 04.11.2023.
//

import UIKit
import ProgressHUD

protocol CatalogViewControllerProtocol: AnyObject {
    var presenter: CatalogPresenterProtocol? { get set }
    func updateTableView()
}

final class CatalogViewController: UIViewController & CatalogViewControllerProtocol {
        
    var presenter: CatalogPresenterProtocol? = {
        return CatalogPresenter()
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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.view = self
        presenter?.viewDidLoad()
        setupViews()
        setupConstraints()
    }
        
    func updateTableView() {
        tableView.reloadData()
    }
    
    // MARK: Selectors
    @objc
    private func sortButtonTapped() {
        #warning("Доделать сортировку")
        let controller = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        controller.addAction(.init(title: "По названию", style: .default, handler: { /*[weak self]*/ _ in
            print("")
        }))
        controller.addAction(.init(title: "По количеству NFT", style: .default, handler: { /*[weak self]*/ _ in
            print("")
        }))
        controller.addAction(.init(title: "Отмена", style: .cancel))
        present(controller, animated: true)
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collections = presenter?.getCollectionsIndex(indexPath.row) else { return }
        let collectionViewController = CollectionViewController(collections: collections)
        navigationController?.pushViewController(collectionViewController, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let collectionsCount = presenter?.collectionsCount else { return 0 }
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
        guard let collections = presenter?.getCollectionsIndex(indexPath.row) else { return }
        cell.setupCell(collections)
    }
}

// MARK: - Setup Views/Constraints
private extension CatalogViewController {
    func setupViews() {
        setupNavigationController()
        setupSortButton()
        view.backgroundColor = .background
        view.addSubviews(tableView)
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
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}
