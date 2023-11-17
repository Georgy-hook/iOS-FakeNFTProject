//
//  Sorting.swift
//  FakeNFT
//
//  Created by Руслан  on 13.11.2023.
//

import Foundation

protocol Sortable {
    func sort(param: Sort)
}

protocol SortingSaveServiceProtocol {
    var savedSorting: Sort { get }
    func saveSorting(param: Sort)
}

enum Sort {
    case NFTCount
    case NFTName
}

enum SortForScreen {
    case catalogue
}
