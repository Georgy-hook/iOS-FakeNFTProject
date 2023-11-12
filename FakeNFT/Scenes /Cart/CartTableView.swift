//
//  CartTableView.swift
//  FakeNFT
//
//  Created by Georgy on 04.11.2023.
//

import UIKit

final class CartTableView:UITableView{
    // MARK: - Variables
    private var items:[Nft] = []
    weak var delegateVC: CartViewControllerDelegate?
    
    // MARK: - Initiliazation
    init() {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.allowsSelection = false
        delegate = self
        dataSource = self
        register(CartCell.self, forCellReuseIdentifier: CartCell.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with nfts:[Nft]){
        items = nfts
        self.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CartTableView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: CartCell.reuseId) as? CartCell
        else { return UITableViewCell() }
        cell.delegateVC = delegateVC
        cell.set(with: items[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension CartTableView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
