//
//  CameraView.swift
//  Camera Example
//
//  Created by Muhammed Karakul on 5.08.2019.
//  Copyright © 2019 Muhammed Karakul. All rights reserved.
//

import UIKit
import SnapKit

protocol CameraViewDelegate: class {
    func cameraView(_ cameraView: CameraView, didTapTakePhotoButton button: UIButton)
    func cameraView(_ cameraView: CameraView, didTapFlashButton button: UIButton)
    func cameraView(_ cameraView: CameraView, didTapSwitchCameraButton button: UIButton)
    func cameraView(_ cameraView: CameraView, didTapPhotoCameraButton button: UIButton)
    func cameraView(_ cameraView: CameraView, didTapVideoCameraButton button: UIButton)
}

final class CameraView: UIView {
    
    // MARK: - Layout Constants
    private struct LayoutConstants {
        let defaultTopOffset: CGFloat = 22.0
        let defaultTrailingOffset: CGFloat = 16.0
        let defaultLeadingOffset: CGFloat = 16.0
        let defaultBottomOffset: CGFloat = 16.0
        let smallButtonSize: CGFloat = 32.0
        let takePhotoButtonCornerRadius: CGFloat = 32.0
        let takePhotoButtonBottomOffset: CGFloat = -16.0
        let takePhotoButtonSize: CGFloat = 64.0
        let switchCameraButtonTopOffset: CGFloat = 8.0
    }
    
    private let layout = LayoutConstants()
    
    // MARK: - Properties
    weak var delegate: CameraViewDelegate?
    
    private lazy var flashButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(named: "Flash Off Icon"), for: .normal)
        button.addTarget(self, action: #selector(didTap(flashButton:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var switchCameraButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(named: "Front Camera Icon"), for: .normal)
        button.addTarget(self, action: #selector(didTap(switchCameraButton:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var photoCameraButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(named: "Photo Camera Icon"), for: .normal)
        button.addTarget(self, action: #selector(didTap(photoCameraButton:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var videoCameraButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(named: "Video Camera Icon"), for: .normal)
        button.addTarget(self, action: #selector(didTap(videoCameraButton:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = layout.takePhotoButtonCornerRadius
        button.addTarget(self, action: #selector(didTap(takePhotoButton:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
        configureAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAppearance() {
        backgroundColor = .black
    }
    
    // MARK: - Layout
    private func prepareLayout() {
        setupTakePhotoButtonLayout()
        setupFlashButtonLayout()
        setupSwitchCameraButtonLayout()
        setupPhotoCameraButtonLayout()
        setupVideoCameraButtonLayout()
    }
    
    private func setupTakePhotoButtonLayout() {
        addSubview(takePhotoButton)
        takePhotoButton.snp.makeConstraints { maker in
            maker.bottom.equalTo(layout.takePhotoButtonBottomOffset)
            maker.size.equalTo(layout.takePhotoButtonSize)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setupFlashButtonLayout() {
        addSubview(flashButton)
        flashButton.snp.makeConstraints { maker in
            maker.size.equalTo(layout.smallButtonSize)
            maker.top.equalTo(layout.defaultTopOffset)
            maker.trailing.equalTo(-layout.defaultTrailingOffset)
        }
    }
    
    private func setupSwitchCameraButtonLayout() {
        addSubview(switchCameraButton)
        switchCameraButton.snp.makeConstraints { maker in
            maker.size.equalTo(layout.smallButtonSize)
            maker.top.equalTo(flashButton.snp.bottom).offset(layout.switchCameraButtonTopOffset)
            maker.trailing.equalTo(-layout.defaultTrailingOffset)
        }
    }
    
    private func setupPhotoCameraButtonLayout() {
        addSubview(photoCameraButton)
        photoCameraButton.snp.makeConstraints { maker in
            maker.size.equalTo(layout.smallButtonSize)
            maker.leading.equalTo(layout.defaultLeadingOffset)
            maker.bottom.equalTo(-layout.defaultBottomOffset)
        }
    }
    
    private func setupVideoCameraButtonLayout() {
        addSubview(videoCameraButton)
        videoCameraButton.snp.makeConstraints { maker in
            maker.size.equalTo(layout.smallButtonSize)
            maker.leading.equalTo(layout.defaultLeadingOffset)
            maker.bottom.equalTo(photoCameraButton.snp.top).offset(-8.0)
        }
    }
}

// MARK: - Selector
extension CameraView {
    @objc
    func didTap(takePhotoButton button: UIButton) {
        delegate?.cameraView(self, didTapTakePhotoButton: button)
    }
    
    @objc
    func didTap(flashButton button: UIButton) {
        delegate?.cameraView(self, didTapFlashButton: button)
    }
    
    @objc
    func didTap(switchCameraButton button: UIButton) {
        delegate?.cameraView(self, didTapSwitchCameraButton: button)
    }
    
    @objc
    func didTap(photoCameraButton button: UIButton) {
        delegate?.cameraView(self, didTapPhotoCameraButton: button)
    }
    
    @objc
    func didTap(videoCameraButton button: UIButton) {
        delegate?.cameraView(self, didTapVideoCameraButton: button)
    }
}
