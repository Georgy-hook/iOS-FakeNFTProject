//
//  SortingSaveService.swift
//  FakeNFT
//
//  Created by Руслан  on 13.11.2023.
//

import Foundation

final class SortingSaveService: SortingSaveServiceProtocol {
    
    private enum Keys: String {
        case sortConfigCatalogue
    }
    
    var savedSorting: Sort {
        var sorting = Sort.NFTName
        
        if let sortConfig, let sortFromConfig = Sort(rawValue: sortConfig) {
            sorting = sortFromConfig
        } else {
            switch screen {
            case .catalogue:
                sorting = .NFTCount
            }
        }
        return sorting
    }
    
    private let userDefaults = UserDefaults.standard
    
    private var screen: SortForScreen
        
    private var sortConfig: String? {
        switch screen {
        case .catalogue:
            return userDefaults.string(forKey: Keys.sortConfigCatalogue.rawValue)
        }
    }
    
    init(screen: SortForScreen) {
        self.screen = screen
    }
    
    func saveSorting(param: Sort) {
        switch screen {
        case .catalogue:
            saveSortingForScreen(param: param, key: Keys.sortConfigCatalogue.rawValue)
        }
    }
    
    private func saveSortingForScreen(param: Sort, key: String) {
        switch param {
        case .NFTCount:
            userDefaults.set(param.rawValue, forKey: key)
        case .NFTName:
            userDefaults.set(param.rawValue, forKey: key)
        }
    }
}
