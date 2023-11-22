//
//  HeartbeatAnimator.swift
//  FakeNFT
//
//  Created by Руслан  on 22.11.2023.
//

import UIKit

struct HeartbeatAnimator {
    private let targetLayer: CALayer

    init(targetLayer: CALayer) {
        self.targetLayer = targetLayer
    }

    func animateHeartbeat() {
        let heartbeatAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        heartbeatAnimation.values = [1.0, 1.1, 1.0]
        heartbeatAnimation.keyTimes = [0, 0.5, 1]
        heartbeatAnimation.timingFunctions = [
            CAMediaTimingFunction(name: .easeInEaseOut),
            CAMediaTimingFunction(name: .easeInEaseOut)
        ]
        heartbeatAnimation.duration = 0.3
        targetLayer.add(heartbeatAnimation, forKey: "heartbeat")
    }
}
