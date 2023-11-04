//  MyNFTViewController.swift
//  FakeNFT
//  Created by Adam West on 04.11.2023.

import UIKit

final class MyNFTViewController: UIViewController {
    // MARK: Private properties
    private lazy var myNFTTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: Methods
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
    
    // MARK: Selectors
    @objc private func filterNFT() {
        #warning("TODO")
    }
    @objc private func goBack() {
        dismiss(animated: true)
    }
}

extension MyNFTViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "LILO"
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
        case 0: print(1)
        case 1: print(2)
        case 2: print(3)
        default: return
        }
    }
    
    
}


// MARK: - Setup views, constraints
private extension MyNFTViewController {
    func setupUI() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        view.addSubviews(myNFTTableView)
        
        NSLayoutConstraint.activate([
            myNFTTableView.topAnchor.constraint(equalTo: view.topAnchor),
            myNFTTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            myNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
