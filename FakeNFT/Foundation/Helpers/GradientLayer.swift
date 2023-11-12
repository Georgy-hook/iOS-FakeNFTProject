//  GradientLayer.swift
//  ImageFeed
//  Created by Adam West on 21.08.23.

import Foundation

import UIKit

final class GradientLayer {
    static var shared = GradientLayer()
    
    // MARK: Added pulse animation to like button(cell)
    func animateLikeButton(_ sender: UIButton) {
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                options: .repeat) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                sender.transform = .init(scaleX: 1.25, y: 1.25)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                sender.transform = .identity
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
                sender.transform = .init(scaleX: 1.25, y: 1.25)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2) {
                sender.transform = .identity
            }
        }
    }
    
    func stopLikeButton(_ cell: FavouriteNFTCell) {
        UIView.transition(with: cell.likeButton,
                          duration: 1,
                          options: .transitionCrossDissolve) {
            cell.likeButton.layer.removeAllAnimations()
        }
    }
}
