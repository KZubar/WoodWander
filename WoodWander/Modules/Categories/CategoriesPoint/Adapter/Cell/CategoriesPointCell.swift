//
//  CategoriesPointCell.swift
//  WoodWander
//
//  Created by k.zubar on 22.08.24.
//

import UIKit
import SnapKit
import Storage
import SwiftIcons

final class CategoriesPointCell: UITableViewCell {

    private enum Icon {
        static let moreHoriz: FontType = UIImage.Categories.moreHoriz
        static let formatListBulleted: FontType = UIImage.Categories.formatListBulleted
    }
    
    private var indexPath: IndexPath = IndexPath()

    var buttonDidTap: ((_ dto: CategoriesPointDTO?) -> Void)?

    private var dto: CategoriesPointDTO?
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont.withSize(20.0)
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let bttn = UIButton()
        bttn.setIcon(
            icon: Icon.moreHoriz,
            iconSize: 20,
            color: .appBlue,
            forState: .normal)
        bttn.setIcon(
            icon: Icon.moreHoriz,
            iconSize: 20,
            color: .appBlueLight,
            forState: .selected)
        //bttn.backgroundColor = .appWhite
        return bttn
    }().withAction(self, #selector(moreButtonDidTap), for: .touchUpInside)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont.withSize(14)
        label.textColor = .mainFont
        return label
    }()
    
//    private lazy var infoText: UILabel = {
//        let label = UILabel()
//        label.font = .appFont.withSize(12)
//        label.textColor = .mainFont
//        return label
//    }()
//    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    func setupCell(_ dto: CategoriesPointDTO, indexPath: IndexPath) {
        
        self.dto = dto
        self.indexPath = indexPath

        self.titleLabel.text = dto.name
        self.titleLabel.textColor = .mainFont

        self.iconLabel.text = dto.icon
        if (self.iconLabel.text ?? "").isEmpty {
            self.iconLabel.setIcon(icon: Icon.formatListBulleted,
                                   iconSize: CGFloat(20.0),
                                   color: .appBlue)
        }
        //self.infoText.text = dto.descr
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(Self.self) was called by coder")
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = false

        self.addSubview(iconLabel)
        self.addSubview(moreButton)
        self.addSubview(titleLabel)
        //self.addSubview(infoText)
    }
    
    private func setupConstraints() {
        iconLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)

            make.leading.equalTo(iconLabel.snp.trailing).inset(-8)
        }
//        infoText.snp.makeConstraints { make in
//            make.verticalEdges.equalToSuperview().inset(12)
//
//            //make.trailing.equalToSuperview().inset(16)
//            make.trailing.equalTo(imgView.snp.trailing).inset(8)
//        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
    }
    
    @objc func moreButtonDidTap(sender: UIView) {
        buttonDidTap?(dto)
    }
    
}
