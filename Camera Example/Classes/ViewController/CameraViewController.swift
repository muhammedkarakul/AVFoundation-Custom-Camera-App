//
//  CameraViewController.swift
//  Camera Example
//
//  Created by Muhammed Karakul on 5.08.2019.
//  Copyright © 2019 Muhammed Karakul. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    private let cameraController = CameraController()
    
    private lazy var cameraView: CameraView = {
        CameraView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        configureAppearance()
        linkInteractors()
        configureCameraController()
    }
    
    private func prepareLayout() {
        view.addSubview(cameraView)
        cameraView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func linkInteractors() {
        cameraView.delegate = self
    }
    
    private func configureAppearance() {
        title = "Camera"
    }
    
    private func configureCameraController() {
        cameraController.prepare { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            try? self.cameraController.displayPreview(on: self.cameraView.photoPreviewImageView)
        }
    }
}

extension CameraViewController: CameraViewDelegate {
    func didTap(takePhotoButton button: UIButton) {
        
    }
}
