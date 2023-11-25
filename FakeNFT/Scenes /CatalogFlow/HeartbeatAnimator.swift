//
//  HeartbeatAnimator.swift
//  FakeNFT
//
//  Created by Руслан  on 22.11.2023.
//

import UIKit

protocol HeartbeatAnimatorProtocol {
    func animationStart(with sender: UIButton, isLiked: Bool)
}

struct HeartbeatAnimator: HeartbeatAnimatorProtocol {
    private func animateHeartbeat(layer: CALayer) {
        let heartbeatAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        heartbeatAnimation.values = [1.0, 1.1, 1.0]
        heartbeatAnimation.keyTimes = [0, 0.5, 1]
        heartbeatAnimation.timingFunctions = [
            CAMediaTimingFunction(name: .easeInEaseOut),
            CAMediaTimingFunction(name: .easeInEaseOut)
        ]
        heartbeatAnimation.duration = 0.3
        layer.add(heartbeatAnimation, forKey: "heartbeat")
    }
    
    func animationStart(with sender: UIButton, isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "activeLike") : UIImage(named: "noActiveLike")
        UIView.transition(with: sender, duration: 0.3, options: .transitionCrossDissolve, animations: {
            sender.setImage(likeImage, for: .normal)
        }, completion: { _ in
            if isLiked {
                animateHeartbeat(layer: sender.layer)
            }
        })
        sender.isUserInteractionEnabled = true
    }
}
