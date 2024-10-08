//
//  CircleView.swift
//  WoodWander
//
//  Created by k.zubar on 10.08.24.
//

import Foundation
import UIKit

final class CircleView: UIView {
    
    private lazy var viewImg: UIImageView = UIImageView()
    private lazy var viewIn: UIView = UIView()

    
    
    // MARK: - public
    
    var image: UIImage? {
        get { viewImg.image }
        set { viewImg.image = newValue }
    }
    var icon: String {
        get { "" }
        set {
            if newValue.isEmpty { viewImg.image = nil; return }

            // Пример строки со смайликом
            let emojiString = newValue
            
            // Создание UILabel для рендеринга смайлика
            let label = UILabel()
            label.text = emojiString
            label.font = UIFont.systemFont(ofSize: 100)
            label.sizeToFit()
            
            // Создание UIImage из UILabel
            UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
            label.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Использование UIImage (например, установка в UIImageView)
            if let image = image {
                viewImg.image = image
            } else {
                print("Не удалось создать UIImage из строки")
            }

            
            
//            // Создание NSAttributedString из строки
//            let attributedString = NSAttributedString(
//                string: newValue,
//                attributes: [.font: UIFont.systemFont(ofSize: 100)]
//            )
//            
//            // Создание UIImage из NSAttributedString
//            let size = attributedString.size()
//            UIGraphicsBeginImageContextWithOptions(size, false, 0)
//            attributedString.draw(at: CGPoint.zero)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            // Использование UIImage (например, установка в UIImageView)
//            if let image = image {
//                viewImg.image = image
//            }

        }
    }
    var backgroundColorIn: UIColor? {
        get { viewIn.backgroundColor }
        set { viewIn.backgroundColor = newValue }
    }
    var backgroundColorImg: UIColor? {
        get { viewImg.backgroundColor }
        set { viewImg.backgroundColor = newValue }
    }
    var contentModeImg: UIView.ContentMode {
        get { viewImg.contentMode }
        set { viewImg.contentMode = newValue }
    }
    var tintColorImg: UIColor? {
        get { viewImg.tintColor }
        set { viewImg.tintColor = newValue }
    }
    var cornerRadiusIn: CGFloat {
        get { viewIn.cornerRadius }
        set { viewIn.cornerRadius = newValue }
    }
    var cornerRadiusImg: CGFloat {
        get { viewImg.cornerRadius }
        set { viewImg.cornerRadius = newValue }
    }
    var isHiddenImage: Bool {
        get { viewImg.isHidden }
        set { viewImg.isHidden = newValue }
    }
    var isHiddenIn: Bool {
        get { viewIn.isHidden }
        set { viewIn.isHidden = newValue }
    }

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
    }
    
    private func setupUI() {
        self.addSubview(viewIn)
        self.addSubview(viewImg)
    }
    
    private func setupConstraints() {
        viewIn.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(1.5)
            make.left.equalTo(self.snp.left).inset(1.5)
            make.bottom.equalTo(self.snp.bottom).inset(1.5)
            make.right.equalTo(self.snp.right).inset(1.5)
        }
        viewImg.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(2.0)
            make.left.equalTo(self.snp.left).inset(2.0)
            make.bottom.equalTo(self.snp.bottom).inset(2.0)
            make.right.equalTo(self.snp.right).inset(2.0)
        }
    }
    
}
