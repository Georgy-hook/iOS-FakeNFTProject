//  MyNFTViewController.swift
//  FakeNFT
//  Created by Adam West on 04.11.2023.

import UIKit

final class MyNFTViewController: UIViewController {
    // MARK: Private properties
    private var myNFT = [1, 2, 3]
    private var emptyLabel = MyNFTLabel(labelType: .big, text: "У Вас еще нет NFT")
    
    private lazy var myNFTTableView: UITableView = {
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
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        showEmptyLabel()
    }
    
    // MARK: Methods
    private func showEmptyLabel() {
        myNFT.isEmpty ? (emptyLabel.isHidden = false) : (emptyLabel.isHidden = true)
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
        let priceAction = UIAlertAction(title: "По цене", style: .default) { _ in //[weak self] _ in
           // guard let self else { return }
            
        }
        let raitingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in //[weak self] _ in
           // guard let self else { return }
            
        }
        let nameAction = UIAlertAction(title: "По названию", style: .default) { _ in //[weak self] _ in
           // guard let self else { return }
            
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(priceAction)
        alert.addAction(raitingAction)
        alert.addAction(nameAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    
    // MARK: Selectors
    @objc private func filterNFT() {
        showFilterAlert()
    }
    @objc private func goBack() {
        dismiss(animated: true)
    }
}

extension MyNFTViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNFT.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as MyNFTCell
        return cell
    }
}


// MARK: - Setup views, constraints
private extension MyNFTViewController {
    func setupUI() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        view.addSubviews(myNFTTableView, emptyLabel)
        
        NSLayoutConstraint.activate([
            myNFTTableView.topAnchor.constraint(equalTo: view.topAnchor),
            myNFTTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            myNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
