//
//  CameraViewController.swift
//  Camera Example
//
//  Created by Muhammed Karakul on 5.08.2019.
//  Copyright © 2019 Muhammed Karakul. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD

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
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
            
            try? self.cameraController.displayPreview(on: self.cameraView)
        }
    }
}

extension CameraViewController: CameraViewDelegate {
    func cameraView(_ cameraView: CameraView, didTapTakePhotoButton button: UIButton) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription ?? "Image capture error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            
            SVProgressHUD.showSuccess(withStatus: "Photo saved to gallery.")
        }
    }
    
    func cameraView(_ cameraView: CameraView, didTapFlashButton button: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            button.setImage(UIImage(named: "Flash Off Icon"), for: .normal)
        } else {
            cameraController.flashMode = .on
            button.setImage(UIImage(named: "Flash On Icon"), for: .normal)
        }
    }
    
    func cameraView(_ cameraView: CameraView, didTapSwitchCameraButton button: UIButton) {
        do {
            try cameraController.switchCameras()
        } catch {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
            button.setImage(UIImage(named: "Front Camera Icon"), for: .normal)
        case .some(.rear):
            button.setImage(UIImage(named: "Rear Camera Icon"), for: .normal)
        case .none:
            return
        }
    }
    
    func cameraView(_ cameraView: CameraView, didTapPhotoCameraButton button: UIButton) {
        print("PHOTO CAMERA BUTTON TAPPED")
    }
    
    func cameraView(_ cameraView: CameraView, didTapVideoCameraButton button: UIButton) {
        print("VIDEO CAMERA BUTTON TAPPED")
    }
}
