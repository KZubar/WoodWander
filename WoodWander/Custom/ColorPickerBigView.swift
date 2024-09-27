//
//  ColorPickerBigView.swift
//  WoodWander
//
//  Created by k.zubar on 17.09.24.
//

import UIKit
import SnapKit
import SwiftIcons


@objc protocol ColorPickerBigViewProtocol: AnyObject {
    @objc optional func clearColor()
    @objc optional func openPickerColor(selectedColor: UIColor)
}

final class ColorPickerBigView: UIView {
    
    private enum Icon {
        static let closeRound: FontType = UIImage.All.closeRound
        static let wallpaper: FontType = UIImage.All.wallpaper
    }
    
    private enum Color {
        static let gray: UIColor = .systemGray3
    }
    
    private enum Size {
        static let sizeView: CGFloat = 130.0
        static let radius: CGFloat = 25.0
        static let radiusCircleBig: CGFloat = 30.0
        static let radiusCircleSmall: CGFloat = 23.0
    }

    //большой цветной квадрат для выбора
    private lazy var colorBackgroundView: UIView = {
        let imgView = UIView()
        imgView.cornerRadius = Size.radius
        imgView.backgroundColor = .appBlueLight
        return imgView
    }()
    
    //надпись под большим квадратом
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите цвет"
        label.font = .appFont.withSize(14.0)
        return label
    }()
    
    //Оконтовка вокруг круга
    private lazy var conturView: UIView = {
        let view = UIView()
        view.cornerRadius = Size.radiusCircleBig
        view.setBorder(width: 0.5, color: Color.gray)
        view.backgroundColor = .appWhite
        return view
    }()

    //сюда положим цвет по умолчанию или цвет выбранный пользователем
    private lazy var colorView: UIView = {
        let view = UIView()
        view.cornerRadius = Size.radiusCircleSmall
        view.setBorder(width: 0.5, color: Color.gray)
        view.backgroundColor = .appWhite
        return view
    }()
        
    private lazy var clearButton: UIButton = {
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
    
    
    
    weak var delegat: ColorPickerBigViewProtocol?

    var colorUser: UIColor? {
        get {
            colorView.backgroundColor
        }
        set {
            colorView.backgroundColor = newValue
            clearButton.isHidden = (newValue == colorDefault)
        }
    }
    var colorDefault: UIColor?

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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureColor))
        self.colorView.addGestureRecognizer(tapGesture)

        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        self.addSubview(self.colorBackgroundView)
        self.addSubview(self.commentLabel)
        self.addSubview(self.conturView)
        self.addSubview(self.clearButton)
        self.conturView.addSubview(self.colorView)
    }
    
    private func setupConstraints() {
        
        //in iconContentView
        colorBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(Size.sizeView)
        }
        commentLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(colorBackgroundView.snp.bottom).inset(-4.0)
        }
        conturView.snp.makeConstraints { make in
            make.center.equalTo(colorBackgroundView.snp.center)
            make.size.equalTo(Size.radiusCircleBig*2)
        }
        colorView.snp.makeConstraints { make in
            make.center.equalTo(conturView.snp.center)
            make.size.equalTo(Size.radiusCircleSmall*2)
        }
        
        //in iconView
        clearButton.snp.makeConstraints { make in
            make.top.equalTo(colorBackgroundView.snp.top).inset(8.0)
            make.right.equalTo(colorBackgroundView.snp.right).inset(8.0)
        }
    }

    @objc private func iconClearButtonDidTap() {
        delegat?.clearColor?()
    }
    
    
    @objc private func tapGestureColor() {
        delegat?.openPickerColor?(selectedColor: colorView.backgroundColor ?? .gradient1)
        
    }

}
