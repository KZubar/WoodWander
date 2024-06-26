//
//  ProfileEmailCell.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit
import SnapKit

fileprivate enum L10n {
    static let your_email: String = "profile_screen_your_email".localizaed
}

final class ProfileEmailCell: UITableViewCell {

    private lazy var titLelabel: UILabel = {
        let label = UILabel()
        label.font = .appFont.withSize(15)
        label.textColor = .black //FIXME: .appCellTitleText
        label.text = L10n.your_email
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont.withSize(17)
        label.textColor = .black //FIXME: .appText
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
 
    func setupCell(_ email: String) {
        self.emailLabel.text = email
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(Self.self) was called by coder")
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    private func setupUI() {
        self.selectionStyle = .none

        self.addSubview(titLelabel)
        self.addSubview(emailLabel)
        
    }
 
    private func setupConstraints() {
        titLelabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            //make.height.equalTo(17)
            make.top.equalToSuperview().inset(16)
        }
        emailLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            
            make.bottom.equalToSuperview().inset(16)
            //make.height.equalTo(20)
            make.top.equalTo(titLelabel.snp.bottom)
            make.bottom.equalToSuperview().inset(16)
       }
    }
}

