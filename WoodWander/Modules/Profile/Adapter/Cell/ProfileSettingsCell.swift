//
//  ProfileSettingsCell.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit
import SnapKit

final class ProfileSettingsCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont.withSize(14)
        label.textColor = .black  //FIXME: .appText
        return label
    }()
    
    private lazy var infoText: UILabel = {
        let label = UILabel()
        label.font = .appFont.withSize(12)
        label.textColor = .black //FIXME: .appCellStatusText
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    func setupCell(_ type: ProfileSettingsRows) {
        self.titleLabel.text = type.title
        //FIXME:
//        self.titleLabel.textColor = type == .logout ?  .appRed : .appText
        self.titleLabel.textColor = type == .logout ?  .red : .black

        self.iconImageView.image = type.icon
        self.infoText.text = type.infoText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(Self.self) was called by coder")
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //    }
    
    private func setupUI() {
        self.selectionStyle = .none
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(infoText)
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(16)

            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            
//            make.verticalEdges.equalToSuperview().inset(12)
//            make.leading.equalToSuperview().inset(16)
        }
        infoText.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)

            make.trailing.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)

            make.leading.equalTo(iconImageView.snp.trailing).inset(-8)
        }
    }
}
