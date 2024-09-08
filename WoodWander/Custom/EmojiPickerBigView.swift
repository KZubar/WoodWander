//
//  EmojiPickerBigView.swift
//  WoodWander
//
//  Created by k.zubar on 28.08.24.
//

import UIKit
import SnapKit
import MCEmojiPicker
import SwiftIcons


@objc protocol EmojiPickerBigViewProtocol: AnyObject {
    @objc optional func clearEmoji()
    @objc optional func openPickerEmoji(sourceView: UIView)
}

final class EmojiPickerBigView: UIView {
    
    private enum Icon {
        static let closeRound: FontType = UIImage.All.closeRound
        static let wallpaper: FontType = UIImage.All.wallpaper
    }
    
    //большой цветной квадрат для выбора иконки
    private lazy var iconBackgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = 25.0
        imgView.backgroundColor = .appBlueLight
        return imgView
    }()
    
    //надпись под большим квадратом
    private lazy var iconCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите значок"
        label.font = .appFont.withSize(14.0)
        return label
    }()
    
    //сюда положим иконку по умолчанию и иконку выбранную пользователем
    private lazy var iconView: UIView = {
        let view = UIView()
        view.cornerRadius = 30.0
        view.backgroundColor = .appWhite
        return view
    }()
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
//        label.isHidden = false //по умолчанию
        label.font = .appFont.withSize(35.0)
        return label
    }()

    private lazy var iconDefaultImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = 30.0
//        imgView.isHidden = true //по умолчанию
        imgView.backgroundColor = .appWhite
        imgView.setIcon(icon: Icon.wallpaper,
                        textColor: .appBlack,
                        backgroundColor: .appWhite,
                        size: CGSize(width: 40.0, height: 40.0))
        imgView.contentMode = .center
        return imgView
    }()
    
    private lazy var iconClearButton: UIButton = {
        let bttn = UIButton()
        bttn.isHidden = true // по умолчанию скрываем
        bttn.setIcon(
            icon: Icon.closeRound,
            iconSize: 16,
            color: .appBlack,
            forState: .normal)
        return bttn
    }().withAction(self,
                   #selector(iconClearButtonDidTap),
                   for: .touchUpInside)
    
    
    weak var delegat: EmojiPickerBigViewProtocol?
    
    var iconUser: String {
        get {
            iconLabel.text ?? ""
        }
        set {
            iconLabel.text = newValue
            let isEmpty = (iconLabel.text ?? "").isEmpty
            iconLabel.isHidden = isEmpty
            iconDefaultImageView.isHidden = !isEmpty
            iconClearButton.isHidden = isEmpty
        }
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

        let tapGestureIconView = UITapGestureRecognizer(target: self, action: #selector(openPickerEmoji))
        self.iconView.addGestureRecognizer(tapGestureIconView)

        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        self.addSubview(self.iconBackgroundImageView)
        self.addSubview(self.iconCommentLabel)
        self.addSubview(self.iconView)
        self.addSubview(self.iconClearButton)

        self.iconView.addSubview(self.iconDefaultImageView)
        self.iconView.addSubview(self.iconLabel)
    }
    
    private func setupConstraints() {
        
        //in iconContentView
        iconBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(130)
        }
        iconCommentLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(iconBackgroundImageView.snp.bottom).inset(-4.0)
        }
        iconView.snp.makeConstraints { make in
            make.center.equalTo(iconBackgroundImageView.snp.center)
            make.size.equalTo(60.0)
        }
        
        //in iconView
        iconDefaultImageView.snp.makeConstraints { make in
            make.center.equalTo(iconView.snp.center)
            make.size.equalTo(60.0)
        }
        iconLabel.snp.makeConstraints { make in
            make.center.equalTo(iconView.snp.center)
        }
        iconClearButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(8.0)
//            make.right.equalToSuperview().inset(8.0)
            make.top.equalTo(iconBackgroundImageView.snp.top).inset(8.0)
            make.right.equalTo(iconBackgroundImageView.snp.right).inset(8.0)
        }
    }

    @objc private func iconClearButtonDidTap() {
        delegat?.clearEmoji?()
    }
    
    @objc private func openPickerEmoji() {
        delegat?.openPickerEmoji?(sourceView: iconBackgroundImageView)
    }

}
