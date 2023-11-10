//  ActivityIndicator.swift
//  MadnessWorld
//  Created by Adam West on 30.10.2023.

import ProgressHUD

protocol InterfaceActivityIndicator {
    func customActivityIndicator()
}

final class ActivityIndicator: InterfaceActivityIndicator {
    func customActivityIndicator() {
        ProgressHUD.animationType = .multipleCirclePulse
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .white
    }
}
