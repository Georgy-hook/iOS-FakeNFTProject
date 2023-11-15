//  AnimateLikeButton.swift
//  FakeNFT
//  Created by Adam West on 21.08.23.

import UIKit

protocol InterfaceAnimateLikeButton {
    func animateLikeButton(_ sender: UIButton)
    func stopLikeButton(_ cell: FavouriteNFTCell)
}

final class AnimateLikeButton: InterfaceAnimateLikeButton {
    // MARK: Added pulse animation to like button(cell)
    public func animateLikeButton(_ sender: UIButton) {
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
    
    public func stopLikeButton(_ cell: FavouriteNFTCell) {
        UIView.transition(with: cell.likeButton,
                          duration: 1,
                          options: .transitionCrossDissolve) {
            cell.likeButton.layer.removeAllAnimations()
        }
    }
}
