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
    func didTap(takePhotoButton button: UIButton)
}

class CameraView: UIView {
    
    weak var delegate: CameraViewDelegate?

    private(set) lazy var photoPreviewImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Take", for: .normal)
        button.addTarget(self, action: #selector(didTap(takePhotoButton:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
        configureAppearance()
    }
    
    private func prepareLayout() {
        addSubview(photoPreviewImageView)
        photoPreviewImageView.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalTo(-100)
        }
        
        addSubview(takePhotoButton)
        takePhotoButton.snp.makeConstraints { maker in
            maker.top.equalTo(photoPreviewImageView.snp.bottom).offset(25)
            maker.bottom.equalToSuperview().offset(-25)
            maker.height.equalTo(50)
            maker.width.equalTo(100)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func configureAppearance() {
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func didTap(takePhotoButton button: UIButton) {
        delegate?.didTap(takePhotoButton: button)
    }
}
