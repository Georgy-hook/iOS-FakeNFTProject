//  UIImage.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import UIKit

extension UIImage {
    // MARK: Convert Png to String
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    // MARK: Convert Jpeg to String
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
