//
//  SortView.swift
//  FakeNFT
//
//  Created by Georgy on 09.11.2023.
//

import UIKit

protocol SortOptionsView {
    func showSortOptions(completion: @escaping (SortOption) -> Void)
}

enum SortOption:String {
    case price
    case rating
    case name
}

extension SortOptionsView where Self: UIViewController {

    func showSortOptions(completion: @escaping (SortOption) -> Void) {
        let title = NSLocalizedString("Sorting", comment: "")
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )

        let priceAction = UIAlertAction(title: NSLocalizedString("By price", comment: ""), style: .default) { _ in
            completion(.price)
        }
        alert.addAction(priceAction)

        let ratingAction = UIAlertAction(title: NSLocalizedString("By rating", comment: ""), style: .default) { _ in
            completion(.rating)
        }
        alert.addAction(ratingAction)

        let nameAction = UIAlertAction(title: NSLocalizedString("By name", comment: ""), style: .default) { _ in
            completion(.name)
        }
        alert.addAction(nameAction)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}

