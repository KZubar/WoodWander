//
//  TabBarButton.swift
//  WoodWander
//
//  Created by k.zubar on 27.08.24.
//

import UIKit
import SnapKit
import SwiftIcons

class TabBarButton: UIButton {
    
    enum ButtonStyle {
        case standard, central
    }

    var color: UIColor = UIColor.lightGray {
        didSet {
            iconLabel.textColor = color
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                iconLabel.textColor = .appBlue
                textLabel.textColor = .appBlue
                if buttonStyle == .central {
                    backgroundColor = .secondaryFont
                    //iconImageView.image = UIImage(named: "cameraActive")
                }
            } else {
                iconLabel.textColor = .tetrialyFont
                textLabel.textColor = .tetrialyFont
                if buttonStyle == .central {
                    backgroundColor = .secondaryFont
                    //iconImageView.image = UIImage(named: "camera")
                }
            }
        }
    }
    
    private let iconLabel: UILabel = UILabel()
    private let textLabel: UILabel = UILabel()
    private let iconImageView: UIImageView = UIImageView()
    let buttonStyle: ButtonStyle
    private let icon: FontType?
    private let text: String?
    
    init(icon: FontType?, style: ButtonStyle, text: String?) {
        self.buttonStyle = style
        self.text = text
        self.icon = icon
        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        switch buttonStyle {
        case .standard:
            guard
                let icon = icon,
                let text = text
                else { fatalError("You have to set icon") }
            
            backgroundColor = .clear
            
            addSubview(iconLabel)
            addSubview(textLabel)

            
            iconLabel.setIcon(icon: icon, iconSize: 28.0, color: .appBlue, bgColor: .clear)
            iconLabel.backgroundColor = .clear

            iconLabel.textColor = .appBlue
            iconLabel.textAlignment = .center
            iconLabel.isUserInteractionEnabled = false

            
            
            
            
            textLabel.text = text
            textLabel.backgroundColor = .clear
            textLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            textLabel.textColor = .appBlack
            textLabel.textAlignment = .center




            iconLabel.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalToSuperview()//.inset(4.0)
                make.bottom.equalTo(textLabel.snp.top)//.inset(4.0)
            }
            textLabel.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(12.0)
                make.bottom.equalToSuperview()
            }
       case .central:
            let iconMargin: CGFloat = 12
            backgroundColor = .mainFont
            layer.borderWidth = 3.0
            layer.borderColor = UIColor.appBackground.cgColor
            addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(iconMargin)
                make.bottom.equalToSuperview().inset(iconMargin)
                make.left.equalToSuperview().inset(iconMargin)
                make.right.equalToSuperview().inset(iconMargin)
            }
            //iconImageView.image = UIImage(named: "camera")
            clipsToBounds = true
        }
    }
}
