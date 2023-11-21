//  String.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import UIKit

extension String {
    // MARK: Convert String to UIImage
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

