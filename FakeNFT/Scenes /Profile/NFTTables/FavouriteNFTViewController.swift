//  FavouriteNFTViewController.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import UIKit

final class FavouriteNFTViewController: UIViewController {
    // MARK: Private properties
    private var favouriteNFT = [1, 2, 3]
    private var emptyLabel = MyNFTLabel(labelType: .big, text: "У Вас еще нет избранных NFT")
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

