//
//  ProfileHeadView.swift
//  WoodWander
//
//  Created by k.zubar on 25.06.24.
//

import UIKit
import SnapKit

final class ProfileHeadView: UIView {

    var headerText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appBoldFont.withSize(14.0)
        label.textColor = .black //FIXME: - .appText
        label.textAlignment = .left
        return label
    }()

    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(16.0)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(-16.0)
        }
    }
}


