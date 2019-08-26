//
//  CameraController.swift
//  Camera Example
//
//  Created by Muhammed Karakul on 6.08.2019.
//  Copyright © 2019 Muhammed Karakul. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraController {
    private var frontCamera: AVCaptureDevice?
    private var rearCamera: AVCaptureDevice?
    private var captureSession: AVCaptureSession?
    private var currentCameraPosition: CameraPosition?
    private var frontCameraInput: AVCaptureDeviceInput?
    private var rearCameraInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
}

extension CameraController {
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .unspecified
            )
            let cameras = session.devices.compactMap { $0 }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                guard let rearCameraInput = self.rearCameraInput else {
                    return
                }
                
                if captureSession.canAddInput(rearCameraInput) {
                    captureSession.addInput(rearCameraInput)
                }
                
                self.currentCameraPosition = .rear
            } else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                guard let frontCameraInput = self.frontCameraInput else {
                    return
                }
                
                if captureSession.canAddInput(frontCameraInput) {
                    captureSession.addInput(frontCameraInput)
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
                
                self.currentCameraPosition = .front
            } else {
                throw CameraControllerError.noCamerasAvailable
            }
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            
            guard let photoOutput = self.photoOutput else {
                return
            }
            
            photoOutput.setPreparedPhotoSettingsArray(
                [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])],
                completionHandler: nil
            )
            
            if captureSession.canAddOutput(photoOutput) { captureSession.addOutput(photoOutput) }
            
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        guard let previewLayer = self.previewLayer else {
            return
        }
        
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.frame
    }
}

extension CameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}
