//
//  NewPlaceDescriptionButtonView.swift
//  WoodWander
//
//  Created by k.zubar on 29.07.24.
//

import UIKit
import SnapKit

@objc protocol NewPlaceDescriptionButtonViewPotocol: AnyObject {
    @objc optional func buttonDidTap(_ view: NewPlaceDescriptionButtonView)
}


final class NewPlaceDescriptionButtonView: UIView {

    // MARK: - private

    private lazy var titleButton: UILabel = {
        let label = UILabel()
        label.font = UIFont.appBoldFont.withSize(11.0)
        label.textColor = .mainFont
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var imageView: UIView = UIView()
    private lazy var imageButton: UIImageView = UIImageView()

    // MARK: - public
    
    var title: String? {
        get { titleButton.text }
        set { titleButton.text = newValue }
    }
    var image: UIImage? {
        get { imageButton.image }
        set { imageButton.image = newValue }
    }

    weak var delegat: NewPlaceDescriptionButtonViewPotocol?


    // MARK: - init()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupConstraints()

        self.isUserInteractionEnabled = true
        self.imageView.isUserInteractionEnabled = false
        self.titleButton.isUserInteractionEnabled = false
        
        // Single Tap
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(viewHandleSingleTap(recognizer:))
        )
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
    }
    
    private func setupUI() {
        self.addSubview(titleButton)
        self.addSubview(imageView)
        self.imageView.addSubview(imageButton)
    }
    
    private func setupConstraints() {
        imageButton.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(30.0)
        }
        
        titleButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func viewHandleSingleTap(recognizer: UITapGestureRecognizer) {
        delegat?.buttonDidTap?(self)
    }

}
