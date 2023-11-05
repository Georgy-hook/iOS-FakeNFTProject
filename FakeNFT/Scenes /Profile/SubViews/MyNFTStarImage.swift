//  MyNFTStarImage.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import UIKit

final class MyNFTStarImage: UIImageView {
    // MARK: Private properties
    private let myNFTStarType: MyNFTStarType
    
    // MARK: Initialisation
    init(myNFTStarType: MyNFTStarType) {
        self.myNFTStarType = myNFTStarType
        super.init(frame: .zero)
        switchTypeStar(myNFTStarType)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    private func switchTypeStar(_ star: MyNFTStarType) {
        switch star {
        case .star:
            self.image = UIImage(named: ImagesAssets.stars.rawValue)
        case .noStar:
            self.image = UIImage(named: ImagesAssets.noStars.rawValue)
        }
    }
    
    
}

