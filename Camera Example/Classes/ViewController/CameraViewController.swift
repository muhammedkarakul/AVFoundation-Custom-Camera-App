//
//  CameraViewController.swift
//  Camera Example
//
//  Created by Muhammed Karakul on 5.08.2019.
//  Copyright © 2019 Muhammed Karakul. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    private let cameraController = CameraController()
    
    private lazy var cameraView: CameraView = {
        CameraView()
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        configureAppearance()
        linkInteractors()
        configureCameraController()
    }
    
    private func configureAppearance() {
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    private func configureCameraController() {
        cameraController.prepare { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            try? self.cameraController.displayPreview(on: self.cameraView)
        }
    }
}

extension CameraViewController: CameraViewDelegate {
    func cameraView(_ cameraView: CameraView, didTapTakePhotoButton button: UIButton) {
        print("TAKE PHOTO BUTTON TAPPED")
    }
    
    func cameraView(_ cameraView: CameraView, didTapFlashButton button: UIButton) {
        print("FLASH BUTTON TAPPED")
    }
    
    func cameraView(_ cameraView: CameraView, didTapSwitchCameraButton button: UIButton) {
        print("SWITCH CAMERA BUTTON TAPPED")
    }
    
    func cameraView(_ cameraView: CameraView, didTapPhotoCameraButton button: UIButton) {
        print("PHOTO CAMERA BUTTON TAPPED")
    }
    
    func cameraView(_ cameraView: CameraView, didTapVideoCameraButton button: UIButton) {
        print("VIDEO CAMERA BUTTON TAPPED")
    }
}
